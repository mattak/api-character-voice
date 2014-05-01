class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :title, :unique => true
      t.date :from

      t.timestamps
    end
    add_index :programs, [:title], :unique => true
  end
end
