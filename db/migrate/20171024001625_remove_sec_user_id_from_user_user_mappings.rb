class RemoveSecUserIdFromUserUserMappings < ActiveRecord::Migration[5.0]
  def change
    remove_column :user_user_mappings, :secUserID, :String
  end
end
