class AddToEvent < ActiveRecord::Migration[8.0]
  def change
    change_table :events, bulk: true do |t|
      t.string  :title, null: false
      t.text    :description
      t.text    :details
      t.string  :event_type, null: false
      t.date    :event_date, null: false
      t.time    :start_time
      t.time    :end_time
      t.string  :location_name
      t.string  :location_address
      t.string  :city, default: "Vallejo"
      t.string  :state, default: "CA"
      t.boolean :is_online, default: false
      t.string  :meeting_link
      t.boolean :is_free, default: true
      t.decimal :cost, precision: 8, scale: 2
      t.string  :rsvp_link
      t.boolean :published, default: false
      t.boolean :featured, default: false
      t.string  :slug
    end

    add_index :events, :event_date
    add_index :events, :event_type
    add_index :events, :published
    add_index :events, :slug, unique: true
  end
end
