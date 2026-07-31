# ── app/models/initiative.rb ─────────────────────────────────────

class Initiative < ApplicationRecord
  has_one_attached :cover_image

  STATUSES = %w[active ongoing completed upcoming].freeze
  FOCUS_AREAS = %w[
    political_advocacy community_organizing black_liberation
    youth_empowerment documentary_media systemic_change
    voter_registration mutual_aid know_your_rights
  ].freeze

  validates :title, :status, :focus_area, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :focus_area, inclusion: { in: FOCUS_AREAS }

  scope :active,    -> { where(status: %w[active ongoing]) }
  scope :published, -> { where(published: true) }
  scope :featured,  -> { where(featured: true) }

  def active? = %w[active ongoing].include?(status)
end