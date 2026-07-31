#!/bin/bash

set -e

echo "Upgrading YBNC models to Lightek contract..."

mkdir -p app/jobs
mkdir -p app/services
mkdir -p app/mailers
mkdir -p app/notifications
mkdir -p app/events


for MODEL in app/models/*.rb
do

  FILE=$(basename "$MODEL" .rb)

  # Skip application/system models
  if [[ "$FILE" == "application_record" || "$FILE" == "application_service" ]]; then
    continue
  fi


  CLASS=$(ruby -e "puts '$FILE'.camelize" 2>/dev/null || echo "$FILE")


  echo "Processing $CLASS"


  # Backup model before modification
  cp "$MODEL" "$MODEL.backup"

  # Add callbacks if missing
  if ! grep -q "trigger_create_job" "$MODEL"; then

    python3 <<PY
from pathlib import Path

path = Path("$MODEL")
content = path.read_text()

insert = """

  after_create_commit :trigger_create_job
  after_update_commit :trigger_update_job
  after_destroy_commit :trigger_destroy_job


  private


  def trigger_create_job
    ${CLASS}CreateJob.perform_later(id)
  end


  def trigger_update_job
    ${CLASS}UpdateJob.perform_later(id)
  end


  def trigger_destroy_job
    ${CLASS}DestroyJob.perform_later(id)
  end

"""

content = content.replace(
    "end\\n",
    insert + "\\nend\\n",
    1
)

path.write_text(content)
PY

  fi



  # Create jobs

  for ACTION in create update destroy
  do

    ACTION_CLASS=$(echo "$ACTION" | sed 's/./\u&/')

    JOB="app/jobs/${FILE}_${ACTION}_job.rb"

    if [ ! -f "$JOB" ]; then

cat > "$JOB" <<RUBY
class ${CLASS}${ACTION_CLASS}Job < ApplicationJob

  queue_as :default

  def perform(id)

    record = ${CLASS}.find_by(id: id)

    result = ${CLASS}${ACTION_CLASS}Service.call(record)

    ${CLASS}Mailer.completed(result).deliver_later

    ${CLASS}Notification.broadcast(result)

    ${CLASS}Event.log(result, "${ACTION}")

  end

end
RUBY

    fi

  done



  # Create services

  for ACTION in create update destroy
  do

SERVICE="app/services/${FILE}_${ACTION}_service.rb"

if [ ! -f "$SERVICE" ]; then

cat > "$SERVICE" <<RUBY
class ${CLASS}${ACTION_CLASS}Service

  def self.call(record)
    new(record).call
  end


  def initialize(record)
    @record = record
  end


  def call

    # ${ACTION} business logic

    @record

  end

end
RUBY

fi

done



# Mailer

MAILER="app/mailers/${FILE}_mailer.rb"

if [ ! -f "$MAILER" ]; then

cat > "$MAILER" <<RUBY
class ${CLASS}Mailer < ApplicationMailer

  def completed(result)

    @result = result

    mail(
      subject: "${CLASS} completed"
    )

  end

end
RUBY

fi



# Notification

NOTIFICATION="app/notifications/${FILE}_notification.rb"

if [ ! -f "$NOTIFICATION" ]; then

cat > "$NOTIFICATION" <<RUBY
class ${CLASS}Notification

  def self.broadcast(result)

    # Notification handling

  end

end
RUBY

fi



# Event

EVENT="app/events/${FILE}_event.rb"

if [ ! -f "$EVENT" ]; then

cat > "$EVENT" <<RUBY
class ${CLASS}Event

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_${FILE}",
      data: result
    )

  end

end
RUBY

fi


done


echo ""
echo "YBNC migration to Lightek contract complete."
echo ""
echo "Review generated files before running the application."