# ── db/seeds.rb ──────────────────────────────────────────────────

puts "✊🏾 Seeding YBNC..."

Event.destroy_all
Initiative.destroy_all
ResourceItem.destroy_all

# ── Events ──

EVENTS = [
  {
    title:         "Community Town Hall — Vallejo",
    description:   "Monthly community gathering to discuss local advocacy priorities and organize action.",
    event_type:    "community",
    event_date:    Date.today + 6,
    start_time:    "18:00",
    location_name: "Vallejo City Hall",
    city:          "Vallejo", state: "CA",
    is_free:       true, published: true, featured: true,
    slug: "community-town-hall-april"
  },
  {
    title:         "Youth Empowerment Workshop",
    description:   "Leadership skills, political education, and community organizing training for young Black individuals ages 16–25.",
    event_type:    "education",
    event_date:    Date.today + 13,
    start_time:    "14:00",
    location_name: "TBD — Vallejo",
    city:          "Vallejo", state: "CA",
    is_free:       true, published: true, featured: false,
    slug: "youth-empowerment-workshop-april"
  },
  {
    title:         "Know Your Rights — Community Training",
    description:   "Free training on your legal rights during encounters with police and during protests. Presented with legal advocates.",
    event_type:    "education",
    event_date:    Date.today + 20,
    start_time:    "16:00",
    is_online:     true,
    location_name: "Online + In-Person",
    city:          "Vallejo", state: "CA",
    is_free:       true, published: true, featured: true,
    slug: "know-your-rights-may"
  },
  {
    title:         "5th Anniversary — Day of Action & Commemoration",
    description:   "Five years since the uprising began May 29, 2020. We commemorate, we organize, we keep moving.",
    event_type:    "commemoration",
    event_date:    Date.new(Date.today.year, 5, 29),
    location_name: "Multiple Locations",
    city:          "Vallejo", state: "CA",
    is_free:       true, published: true, featured: true,
    slug: "5th-anniversary-day-of-action-2025"
  }
].freeze

EVENTS.each { |e| Event.create!(e); print "." }

# ── Initiatives ──

INITIATIVES = [
  {
    title:       "Voter Registration & Political Education",
    description: "Mobilizing Black communities around elections, policy, and holding officials accountable.",
    focus_area:  "political_advocacy",
    status:      "active", published: true, featured: true, sort_order: 1
  },
  {
    title:       "Frontline Documentary Project",
    description: "Documenting social injustice across America — on the ground, in real time, for the historical record.",
    focus_area:  "documentary_media",
    status:      "ongoing", published: true, featured: true, sort_order: 2
  },
  {
    title:       "Know Your Rights Community Training",
    description: "Free legal education workshops in partnership with attorneys and legal advocates.",
    focus_area:  "know_your_rights",
    status:      "active", published: true, featured: false, sort_order: 3
  }
].freeze

INITIATIVES.each { |i| Initiative.create!(i); print "." }

# ── Resources ──

RESOURCES = [
  { title: "Know Your Rights During a Police Stop",   category: "know_your_rights",   published: true },
  { title: "Voter Registration — California",          category: "voting_rights",       published: true },
  { title: "Protest Safety Guide",                    category: "community_organizing", published: true },
  { title: "Mental Health Resources for Activists",   category: "mental_health",       published: true },
  { title: "Community Organizing Starter Kit",        category: "community_organizing", published: true },
  { title: "Legal Aid Contacts — Northern California",category: "legal_aid",           published: true },
].freeze

RESOURCES.each { |r| ResourceItem.create!(r); print "." }

puts "\n✅ YBNC seeding complete. Power to the people! ✊🏾"