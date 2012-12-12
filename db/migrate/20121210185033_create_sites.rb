class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.integer :user_id
      t.string :api_key
      t.string :name

      t.timestamps
    end
  end
end
