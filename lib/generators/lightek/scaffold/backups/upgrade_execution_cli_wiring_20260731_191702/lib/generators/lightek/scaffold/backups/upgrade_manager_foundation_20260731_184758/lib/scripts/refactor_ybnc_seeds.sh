#!/bin/bash

set -e

echo "Refactoring YBNC seeds..."

SEEDS_DIR="db/seeds"

mkdir -p "$SEEDS_DIR"

if [ -f "db/seeds.rb" ]; then
  cp db/seeds.rb db/seeds.rb.backup
fi


cat > "$SEEDS_DIR/events.rb" <<'RUBY'
puts "Seeding events..."

Event.destroy_all

EVENTS = [
  {
    title: "Community Town Hall — Vallejo",
    description: "Monthly community gathering to discuss local advocacy priorities and organize action.",
    event_type: "community",
    event_date: Date.today + 6,
    start_time: "18:00",
    location_name: "Vallejo City Hall",
    city: "Vallejo",
    state: "CA",
    is_free: true,
    published: true,
    featured: true,
    slug: "community-town-hall-april"
  },
  {
    title: "Youth Empowerment Workshop",
    description: "Leadership skills, political education, and community organizing training.",
    event_type: "education",
    event_date: Date.today + 13,
    start_time: "14:00",
    location_name: "TBD — Vallejo",
    city: "Vallejo",
    state: "CA",
    is_free: true,
    published: true,
    featured: false,
    slug: "youth-empowerment-workshop-april"
  }
]

EVENTS.each do |event|
  Event.create!(event)
end

puts "Events complete."
RUBY


cat > "$SEEDS_DIR/initiatives.rb" <<'RUBY'
puts "Seeding initiatives..."

Initiative.destroy_all

INITIATIVES = [
  {
    title: "Voter Registration & Political Education",
    description: "Mobilizing communities around elections and policy.",
    focus_area: "political_advocacy",
    status: "active",
    published: true,
    featured: true,
    sort_order: 1
  },
  {
    title: "Frontline Documentary Project",
    description: "Documenting social injustice.",
    focus_area: "documentary_media",
    status: "ongoing",
    published: true,
    featured: true,
    sort_order: 2
  }
]

INITIATIVES.each do |initiative|
  Initiative.create!(initiative)
end

puts "Initiatives complete."
RUBY


cat > "$SEEDS_DIR/resources.rb" <<'RUBY'
puts "Seeding resources..."

ResourceItem.destroy_all

RESOURCES = [
  {
    title: "Know Your Rights During a Police Stop",
    category: "know_your_rights",
    published: true
  },
  {
    title: "Voter Registration — California",
    category: "voting_rights",
    published: true
  },
  {
    title: "Protest Safety Guide",
    category: "community_organizing",
    published: true
  }
]

RESOURCES.each do |resource|
  ResourceItem.create!(resource)
end

puts "Resources complete."
RUBY


cat > db/seeds.rb <<'RUBY'
# ── db/seeds.rb ──────────────────────────────────────────────────

puts "✊🏾 Seeding YBNC..."

load Rails.root.join("db/seeds/users.rb")
load Rails.root.join("db/seeds/events.rb")
load Rails.root.join("db/seeds/initiatives.rb")
load Rails.root.join("db/seeds/resources.rb")

puts "✅ YBNC seeding complete."
RUBY


echo "Seed refactor complete."
echo ""
echo "Created:"
echo "  db/seeds/events.rb"
echo "  db/seeds/initiatives.rb"
echo "  db/seeds/resources.rb"
echo ""
echo "Backup:"
echo "  db/seeds.rb.backup"