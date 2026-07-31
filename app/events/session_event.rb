class sessionEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_session",
      data: result
    )

  end

end
