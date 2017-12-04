class AddIndexToUserInterestMappings < ActiveRecord::Migration[5.0]
  def change
    add_index :user_interest_mappings, :interestID
  end
end
