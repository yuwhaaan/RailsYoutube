class AddOmniauthToUsers < ActiveRecord::Migration[7.1]
  def change
    # Check and modify the columns as needed
    add_column :users, :uid, :string unless column_exists?(:users, :uid)
    add_column :users, :token, :string unless column_exists?(:users, :token)
    add_column :users, :refresh_token, :string unless column_exists?(:users, :refresh_token)
    add_column :users, :token_expires_at, :datetime unless column_exists?(:users, :token_expires_at)
  end
  
end
