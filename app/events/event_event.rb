class eventEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_event",
      data: result
    )

  end

end
