# ── app/models/volunteer_application.rb ──────────────────────────

class VolunteerApplication < ApplicationRecord
  SKILL_AREAS = %w[
    legal_support graphic_design event_organizing
    social_media outreach translation journalism
    fundraising photography videography
    community_outreach administrative tech_support
  ].freeze

  STATUSES = %w[pending reviewed accepted declined].freeze

  validates :first_name, :last_name, :email, presence: true
  validates :status, inclusion: { in: STATUSES }

  before_validation :set_defaults
  after_create :send_confirmation

  scope :pending,  -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }
  scope :recent,   -> { order(created_at: :desc) }

  def full_name   = "#{first_name} #{last_name}"
  def accept!     = update!(status: "accepted") && send_acceptance
  def decline!    = update!(status: "declined") && send_decline

  private

  def set_defaults
    self.status ||= "pending"
  end

  def send_confirmation
    VolunteerMailer.application_received(self).deliver_later
    VolunteerMailer.new_application_alert(self).deliver_later
  end

  def send_acceptance
    VolunteerMailer.accepted(self).deliver_later
  end

  def send_decline
    VolunteerMailer.declined(self).deliver_later
  end
end

