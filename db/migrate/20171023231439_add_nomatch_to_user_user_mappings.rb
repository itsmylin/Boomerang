class AddNomatchToUserUserMappings < ActiveRecord::Migration[5.0]
  def change
    add_column :user_user_mappings, :nomatch, :string
  end
end
