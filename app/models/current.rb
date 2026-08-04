class Current < ActiveSupport::CurrentAttributes

  # This automatically exposes Current.user by pulling it from Current.session
  delegate :user, to: :session, allow_nil: true

  attribute :actor
  attribute :user
  attribute :request_id
  attribute :session, :user
  
  resets do

    Time.zone = nil

  end


end
