# ── db/migrate/XXXXXX_newsletter_subscriptions.rb ─────────

class NewsletterSubscriptions < ActiveRecord::Migration[8.0]
  def change
    change_table :newsletter_subscriptions do |t|
      t.string  :email,            null: false
      t.string  :first_name
      t.string  :status,           default: "active"
      t.string  :token
      t.string  :source           # home, event, footer, etc.
      t.datetime :unsubscribed_at

      #t.timestamps
    end
    add_index :newsletter_subscriptions, :email, unique: true
    add_index :newsletter_subscriptions, :status
    add_index :newsletter_subscriptions, :token, unique: true
  end
end
