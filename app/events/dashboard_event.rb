class dashboardEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_dashboard",
      data: result
    )

  end

end
