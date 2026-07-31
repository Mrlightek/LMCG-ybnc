class Current < ActiveSupport::CurrentAttributes

  attribute :actor
  attribute :user
  attribute :request_id


  resets do

    Time.zone = nil

  end


end
