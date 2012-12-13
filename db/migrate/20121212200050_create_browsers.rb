class CreateBrowsers < ActiveRecord::Migration
  def change
    create_table :browsers do |t|
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end

    add_index :browsers, :name
    add_index :browsers, :parent_id

    add_column :visits, :browser_id, :integer
    add_index :visits, :browser_id
  end
end
