puts "Seeding <%= class_name %>..."


5.times do |i|

  <%= class_name %>.create!(

<% attributes.each do |attribute| %>

    <%= attribute.name %>:
      <%= attribute_value(attribute) %>,

<% end %>

  )

end


puts "<%= class_name %> seeded."
