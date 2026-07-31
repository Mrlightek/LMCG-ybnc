puts "Creating users..."

admin = User.find_or_create_by!(email_address: "marlon@ybnc.com") do |user|
  user.password = "Password123!"
  user.password_confirmation = "Password123!"
  user.role = :admin
end

regular = User.find_or_create_by!(email_address: "user@ybnc.com") do |user|
  user.password = "Password123!"
  user.password_confirmation = "Password123!"
  user.role = :member
end

puts "Created admin: #{admin.email_address}"
puts "Created member: #{regular.email_address}"