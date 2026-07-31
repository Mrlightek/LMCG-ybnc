class skillEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_skill",
      data: result
    )

  end

end
