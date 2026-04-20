# ── app/models/resource_item.rb ──────────────────────────────────

class ResourceItem < ApplicationRecord
  has_one_attached :file_attachment

  CATEGORIES = %w[
    know_your_rights voting_rights community_organizing
    mental_health legal_aid housing economic_justice
    education health_equity media_toolkit
  ].freeze

  validates :title, :category, presence: true
  validates :category, inclusion: { in: CATEGORIES }

  scope :published,  -> { where(published: true) }
  scope :by_category,->(c) { where(category: c) if c.present? }
  scope :featured,   -> { where(featured: true) }
  scope :ordered,    -> { order(:sort_order, :title) }
end