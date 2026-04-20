# ── app/mailers/newsletter_mailer.rb ─────────────────────────────

class NewsletterMailer < ApplicationMailer
  default from: "YBNC <connect@ybnc.org>"

  def welcome(subscription)
    @subscription = subscription
    @unsubscribe_url = unsubscribe_url(token: subscription.token)
    mail(
      to:      subscription.email,
      subject: "✊🏾 Welcome to YBNC — Young Black Nameless Coalition"
    )
  end

  def broadcast(subscription, newsletter)
    @subscription = subscription
    @newsletter   = newsletter
    @unsubscribe_url = unsubscribe_url(token: subscription.token)
    mail(to: subscription.email, subject: newsletter.subject)
  end
end