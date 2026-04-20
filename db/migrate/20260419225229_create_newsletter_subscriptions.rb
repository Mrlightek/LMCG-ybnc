class CreateNewsletterSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :newsletter_subscriptions do |t|
      t.timestamps
    end
  end
end
