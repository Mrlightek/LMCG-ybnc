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
