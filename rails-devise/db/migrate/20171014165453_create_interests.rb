class CreateInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :interests do |t|
         t.column :name, :string, :limit => 32, :null => false
         t.column :timeSlot, :string
         t.column :location, :string
         t.column :description, :string
      t.timestamps
    end
  end
end
