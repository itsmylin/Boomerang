class CreateUserInterestMappings < ActiveRecord::Migration[5.0]
  def change
    create_table :user_interest_mappings do |t|
        t.column :userID, :string, :null=> false
        t.column :interestID, :string,:null => false
        t.column :desciption, :string

      t.timestamps
    end
  end
end
 
