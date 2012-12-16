class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.timestamps
    end

    add_column :users, :account_id, :integer
    add_index :users, :account_id

    rename_column :sites, :user_id, :account_id
    add_index :sites, :account_id
  end
end
