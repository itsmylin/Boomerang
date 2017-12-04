class AddIndexToUserUserMappings < ActiveRecord::Migration[5.0]
  def change
    add_index :user_user_mappings, :primeUserID
  end
end
