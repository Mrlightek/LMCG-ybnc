class volunteer_applicationEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_volunteer_application",
      data: result
    )

  end

end
