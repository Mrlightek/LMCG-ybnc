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
  

  after_create_commit :trigger_create_job
  after_update_commit :trigger_update_job
  after_destroy_commit :trigger_destroy_job


  private


  def trigger_create_job
    contact_messageCreateJob.perform_later(id)
  end


  def trigger_update_job
    contact_messageUpdateJob.perform_later(id)
  end


  def trigger_destroy_job
    contact_messageDestroyJob.perform_later(id)
  end


end

  def send_notifications
    ContactMailer.auto_reply(self).deliver_later
    ContactMailer.new_message_alert(self).deliver_later
  end
end
