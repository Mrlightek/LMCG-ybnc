# ── app/controllers/admin/dashboard_controller.rb ───────────────

class Admin::DashboardController < Admin::BaseController
  def index
    @upcoming_events_count    = Event.published.upcoming.count
    @pending_volunteers_count = VolunteerApplication.pending.count
    @unread_messages_count    = ContactMessage.unread.count
    @subscriber_count         = NewsletterSubscription.active.count
    @recent_subscribers       = NewsletterSubscription.order(created_at: :desc).limit(5)
    @pending_volunteers        = VolunteerApplication.pending.recent.limit(5)
    @unread_messages          = ContactMessage.unread.recent.limit(5)
    @upcoming_events          = Event.published.upcoming.limit(5)
  end
end

