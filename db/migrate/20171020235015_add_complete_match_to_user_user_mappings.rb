class AddCompleteMatchToUserUserMappings < ActiveRecord::Migration[5.0]
  def change
    add_column :user_user_mappings, :completematch, :string
  end
end
