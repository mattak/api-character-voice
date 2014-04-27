class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.string :actor
      t.integer :program_id

      t.timestamps
    end
  end
end
