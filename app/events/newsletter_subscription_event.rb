class newsletter_subscriptionEvent

  def self.log(result, action)

    EventLog.create!(
      event_type: "\#{action}_newsletter_subscription",
      data: result
    )

  end

end
