# ── app/models/contact_message.rb ────────────────────────────────

class ContactMessage < ApplicationRecord
  INQUIRY_TYPES = %w[
    general partnership media_press
    donation legal collaboration other
  ].freeze

  validates :name, :email, :message, presence: true
  validates :inquiry_type, inclusion: { in: INQUIRY_TYPES }, allow_blank: true

  before_validation :set_defaults
  after_create :send_notifications

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }

  def mark_read! = update!(read: true)

  private

  def set_defaults
    self.read ||= false
    self.inquiry_type ||= "general"
  end

  def send_notifications
    ContactMailer.auto_reply(self).deliver_later
    ContactMailer.new_message_alert(self).deliver_later
  end
end
