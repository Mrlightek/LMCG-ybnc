class newsletter_subscriptionuupdateJob < ApplicationJob

  queue_as :default

  def perform(id)

    record = newsletter_subscription.find_by(id: id)

    result = newsletter_subscriptionuupdateService.call(record)

    newsletter_subscriptionMailer.completed(result).deliver_later

    newsletter_subscriptionNotification.broadcast(result)

    newsletter_subscriptionEvent.log(result, "update")

  end

end
