class CreateSpecies < ActiveRecord::Migration[8.1]
  def change
    create_table :species do |t|
      t.string :common_name
      t.string :scientific_name
      t.string :taxonomy_class
      t.string :conservation_status

      t.timestamps
    end
  end
end
