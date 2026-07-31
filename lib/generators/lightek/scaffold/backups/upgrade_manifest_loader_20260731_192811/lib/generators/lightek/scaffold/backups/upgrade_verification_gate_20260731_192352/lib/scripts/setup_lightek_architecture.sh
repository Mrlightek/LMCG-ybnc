#!/bin/bash

set -e

echo "Creating Lightek architecture..."

mkdir -p lib/generators/lightek/scaffold/templates/views
mkdir -p app/services
mkdir -p app/jobs
mkdir -p app/mailers
mkdir -p app/notifications
mkdir -p app/events

cat > app/services/application_service.rb <<'RUBY'
class ApplicationService

  def self.call(...)
    new(...).call
  end

end
RUBY


cat > app/events/event_log.rb <<'RUBY'
class EventLog < ApplicationRecord
end
RUBY


cat > app/jobs/example_job.rb <<'RUBY'
class ExampleJob < ApplicationJob

  queue_as :default

  def perform(record_id)

    record = Example.find(record_id)

    result = ExampleService.call(record)

    ExampleMailer.completed(result).deliver_later

    ExampleNotification.broadcast(result)

    EventLog.create!(
      event_type: "example_completed",
      data: result
    )

  end

end
RUBY


cat > app/services/example_service.rb <<'RUBY'
class ExampleService < ApplicationService

  def initialize(record)
    @record = record
  end


  def call

    # Business logic here

    @record

  end


end
RUBY


cat > app/notifications/example_notification.rb <<'RUBY'
class ExampleNotification

  def self.broadcast(result)

    # Notification logic here

  end

end
RUBY


cat > app/mailers/example_mailer.rb <<'RUBY'
class ExampleMailer < ApplicationMailer

  def completed(result)
    @result = result

    mail(
      subject: "Process completed"
    )
  end

end
RUBY


echo "Lightek architecture scaffold created."
