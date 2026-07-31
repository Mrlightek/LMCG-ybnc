class initiativeEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_initiative",
      data: result
    )

  end

end
