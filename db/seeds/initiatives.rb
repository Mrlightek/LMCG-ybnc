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
