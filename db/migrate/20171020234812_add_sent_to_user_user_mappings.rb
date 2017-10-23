class AddSentToUserUserMappings < ActiveRecord::Migration[5.0]
  def change
    add_column :user_user_mappings, :sent, :string
  end
end
