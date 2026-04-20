# ── app/controllers/pages_controller.rb ─────────────────────────

class PagesController < ApplicationController
  def home
    @upcoming_events    = Event.published.upcoming.limit(5)
    @featured_initiatives = Initiative.published.featured.active.limit(3)
    @newsletter_sub     = NewsletterSubscription.new
  end

  def mission;   end
  def focus;     end
  def about;     end
  def contact;   @message = ContactMessage.new; end
  def resources; @resources = ResourceItem.published.ordered.group_by(&:category); end
  def privacy;   end
  def donate;    end
end