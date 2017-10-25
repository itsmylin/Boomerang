class RemoveTypeNameFromUserUserMappings < ActiveRecord::Migration[5.0]
  def change
    remove_column :user_user_mappings, :typeName, :String
  end
end
