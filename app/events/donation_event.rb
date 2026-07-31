class donationEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_donation",
      data: result
    )

  end

end
