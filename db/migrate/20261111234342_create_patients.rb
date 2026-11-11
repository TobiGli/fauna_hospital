class CreatePatients < ActiveRecord::Migration[8.1]
  def change
    create_table :patients do |t|
      t.string :identifier
      t.string :name
      t.references :species, null: false, foreign_key: true
      t.date :admission_date
      t.string :status
      t.jsonb :custom_metrics

      t.timestamps
    end
  end
end
