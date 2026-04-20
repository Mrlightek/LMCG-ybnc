# app/jobs/event_notification_job.rb
class EventNotificationJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = Event.find_by(id: event_id)
    return unless event
    return unless event.published?
    return unless event.upcoming?

    # TODO:
    # put your notification logic here
    # examples:
    # NewsletterSubscription.active.find_each do |subscriber|
    #   EventMailer.notify_subscriber(subscriber, event).deliver_later
    # end
  end
end