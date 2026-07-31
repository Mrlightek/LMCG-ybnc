class currentEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_current",
      data: result
    )

  end

end
