class articleEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_article",
      data: result
    )

  end

end
