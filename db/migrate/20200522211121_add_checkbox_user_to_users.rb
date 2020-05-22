class AddCheckboxUserToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :checkbox_user, :boolean, default: false, null: false
  end
end
