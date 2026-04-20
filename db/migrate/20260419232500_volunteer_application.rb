# ── db/migrate/XXXXXX_create_volunteer_applications.rb ───────────

class VolunteerApplication < ActiveRecord::Migration[8.0]
  def change
    change_table :volunteer_applications do |t|
      t.string  :first_name,    null: false
      t.string  :last_name,     null: false
      t.string  :email,         null: false
      t.string  :phone
      t.string  :city
      t.string  :state
      t.json  :skill_areas, default: []
      t.text    :why_join
      t.text    :skills_description
      t.boolean :can_donate_time, default: false
      t.string  :availability
      t.string  :status,        default: "pending"
      t.text    :internal_notes
    end
    add_index :volunteer_applications, :status
    add_index :volunteer_applications, :email
  end
end
