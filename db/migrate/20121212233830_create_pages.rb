class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :site_id
      t.string :path

      t.timestamps
    end

    add_index :pages, :site_id
    add_index :pages, :path
    
    add_column :visits, :page_id, :integer
    add_index :visits, :page_id
  end
end
