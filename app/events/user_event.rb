class userEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_user",
      data: result
    )

  end

end
