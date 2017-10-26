class CreateUserUserMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :user_user_mappings do |t|
        t.column :primeUserID, :string, :null=> false
        t.column :timeslot, :string,:null => false
        t.column :sent, :string
        t.column :received, :string
        t.column :completematch, :string
        t.column :nomatch, :string

      t.timestamps
    end
  end
end
