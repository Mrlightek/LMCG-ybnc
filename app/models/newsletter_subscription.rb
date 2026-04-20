# ── app/models/newsletter_subscription.rb ───────────────────────

class NewsletterSubscription < ApplicationRecord
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :status, inclusion: { in: %w[active unsubscribed] }

  before_validation :normalize_email
  before_validation :set_defaults
  after_create :send_welcome

  scope :active, -> { where(status: "active") }

  def unsubscribe!
    update!(status: "unsubscribed", unsubscribed_at: Time.current)
  end

  private

  def normalize_email
    self.email = email&.downcase&.strip
  end

  def set_defaults
    self.status ||= "active"
    self.token  ||= SecureRandom.urlsafe_base64(20)
  end

  def send_welcome
    NewsletterMailer.welcome(self).deliver_later
  end
end