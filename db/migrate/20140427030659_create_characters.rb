class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :program_id
      t.integer :actor_id

      t.timestamps
    end
  end
end
