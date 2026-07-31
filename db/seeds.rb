puts "Loading Lightek seeds..."

Dir[
  Rails.root.join(
    "db/seeds/*_seeds.rb"
  )
].sort.each do |seed|

  load seed

end


puts "Lightek seeds complete."
