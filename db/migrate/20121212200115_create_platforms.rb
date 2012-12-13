class CreatePlatforms < ActiveRecord::Migration
  def change
    create_table :platforms do |t|
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end

    add_index :platforms, :name
    add_index :platforms, :parent_id

    add_column :visits, :platform_id, :integer
    add_index :visits, :platform_id
  end
end
