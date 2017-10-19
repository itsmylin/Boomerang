class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
  	rename_column :user_user_mappings, :type, :typeName
  end
end
