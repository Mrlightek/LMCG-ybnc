json.extract! donation, :id, :user_id, :amount, :method, :note, :created_at, :updated_at
json.url donation_url(donation, format: :json)
