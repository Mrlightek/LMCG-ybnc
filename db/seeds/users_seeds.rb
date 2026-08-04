puts "Creating users..."

# 1. Admin
admin = User.find_or_initialize_by(email_address: "marlon@ybnc.com")
admin.first_name = "Marlon"
admin.last_name = "Henry"
admin.title = "Head Muslim in charge"
admin.password = "Password123!"
admin.password_confirmation = "Password123!"
admin.role = :admin
admin.status = :active
admin.save! # Explicitly save to database

# 2. Ashley
regular1 = User.find_or_initialize_by(email_address: "user@ybnc.com")
regular1.first_name = "Ashley"
regular1.last_name = "Dorelus"
regular1.title = "Founder"
regular1.password = "Password123!"
regular1.password_confirmation = "Password123!"
regular1.role = :admin
regular1.status = :active
regular1.save!

# 3. Marcus
regular2 = User.find_or_initialize_by(email_address: "marcus.t@email.com")
regular2.first_name = "Marcus"
regular2.last_name = "Thompson"
regular2.password = "Password123!"
regular2.password_confirmation = "Password123!"
regular2.role = :member
regular2.status = :active
regular2.save!

# 4. Keisha
regular3 = User.find_or_initialize_by(email_address: "keisha.m@email.com")
regular3.first_name = "Keisha "
regular3.last_name = "Morales"
regular3.password = "Password123!"
regular3.password_confirmation = "Password123!"
regular3.role = :member
regular3.status = :active
regular3.save!

# 5. Jordan
regular4 = User.find_or_initialize_by(email_address: "j.williams@email.com")
regular4.first_name = "Jordan"
regular4.last_name = "Williams"
regular4.password = "Password123!"
regular4.password_confirmation = "Password123!"
regular4.role = :member
regular4.status = :pending
regular4.save!

# 6. Destiny
regular5 = User.find_or_initialize_by(email_address: "d.moore@email.com")
regular5.first_name = "Destiny"
regular5.last_name = "Moore"
regular5.password = "Password123!"
regular5.password_confirmation = "Password123!"
regular5.role = :member
regular5.status = :pending
regular5.save!

puts "Seeds completed successfully!"
puts "Total Users in DB: #{User.count}"
