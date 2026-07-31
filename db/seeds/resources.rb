puts "Seeding resources..."

ResourceItem.destroy_all

RESOURCES = [
  {
    slug: title.to_s.parameterize,
    title: "Know Your Rights During a Police Stop",
    category: "know_your_rights",
    published: true
  },
  {
    slug: title.to_s.parameterize,
    title: "Voter Registration — California",
    category: "voting_rights",
    published: true
  },
  {
    slug: title.to_s.parameterize,
    title: "Protest Safety Guide",
    category: "community_organizing",
    published: true
  }
]

RESOURCES.each do |resource|
  ResourceItem.create!(resource)
end

puts "Resources complete."
