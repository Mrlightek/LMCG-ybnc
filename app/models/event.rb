# ── app/models/event.rb ──────────────────────────────────────────

class Event < ApplicationRecord
  has_one_attached :image
  has_many :event_rsvps, dependent: :destroy

  TYPES = %w[advocacy community education rally fundraiser commemoration].freeze

  validates :title, :event_date, :event_type, presence: true
  validates :event_type, inclusion: { in: TYPES }

  scope :upcoming,   -> { where("event_date >= ?", Date.today).order(:event_date) }
  scope :past,       -> { where("event_date < ?",  Date.today).order(event_date: :desc) }
  scope :published,  -> { where(published: true) }
  scope :featured,   -> { where(featured: true) }
  scope :by_type,    ->(t) { where(event_type: t) if t.present? }

  after_create :notify_subscribers

  def past?     = event_date < Date.today
  def upcoming? = event_date >= Date.today
  def rsvp_count = event_rsvps.count

  def type_badge_class
    {
      "advocacy"      => "event-type--advocacy",
      "community"     => "event-type--community",
      "education"     => "event-type--education",
      "rally"         => "event-type--advocacy",
      "fundraiser"    => "event-type--community",
      "commemoration" => "event-type--advocacy"
    }.fetch(event_type, "event-type--education")
  end

  private

  def notify_subscribers
    return unless published? && upcoming?
    EventNotificationJob.perform_later(id)
  end
end