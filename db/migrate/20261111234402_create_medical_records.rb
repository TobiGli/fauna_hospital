class CreateMedicalRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :medical_records do |t|
      t.references :patient, null: false, foreign_key: true
      t.decimal :weight
      t.decimal :temperature
      t.text :diagnosis
      t.text :treatment_plan

      t.timestamps
    end
  end
end
