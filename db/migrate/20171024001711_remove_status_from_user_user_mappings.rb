class RemoveStatusFromUserUserMappings < ActiveRecord::Migration[5.0]
  def change
    remove_column :user_user_mappings, :status, :String
  end
end
