class CreateProgramStaffs < ActiveRecord::Migration
  def change
    create_table :program_staffs do |t|
      t.integer :staff_id
      t.integer :program_id
      t.string :role

      t.timestamps
    end
  end
end
