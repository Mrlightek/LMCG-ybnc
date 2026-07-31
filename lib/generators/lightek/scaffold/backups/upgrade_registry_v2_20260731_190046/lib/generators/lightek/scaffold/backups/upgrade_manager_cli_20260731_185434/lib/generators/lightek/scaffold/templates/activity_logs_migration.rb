class CreateActivityLogs < ActiveRecord::Migration[8.0]


  def change


    create_table :activity_logs do |t|


      t.string :action,
        null: false


      t.string :status,
        null: false



      t.references :actor,
        polymorphic: true,
        null: false



      t.references :record,
        polymorphic: true,
        null: false



      t.text :message



      t.timestamps


    end



    add_index :activity_logs,
      [:actor_type, :actor_id]


    add_index :activity_logs,
      [:record_type, :record_id]


    add_index :activity_logs,
      :action


    add_index :activity_logs,
      :status


  end


end
