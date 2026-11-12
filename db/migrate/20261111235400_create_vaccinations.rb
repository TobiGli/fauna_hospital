class CreateVaccinations < ActiveRecord::Migration[8.1]
  def change
    create_table :vaccinations do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :vaccine_name, null: false
      t.date :applied_at, null: false
      t.date :next_due_at, null: false
      t.decimal :dose
      t.text :notes
      t.datetime :reminder_sent_at
      t.timestamps
    end
  end
end
