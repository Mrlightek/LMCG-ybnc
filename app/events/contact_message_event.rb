class contact_messageEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_contact_message",
      data: result
    )

  end

end
