class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :site_id
      t.datetime :timestamp
      t.inet :ip_address
      t.uuid :visitor_id
      t.datetime :previous_visit
      t.string :previous_page
      t.string :user_agent
      t.string :platform
      t.boolean :cookies_enabled
      t.boolean :java_enabled
      t.text :plugins
      t.integer :screen_height
      t.integer :screen_width
      t.integer :screen_colour_depth
      t.integer :screen_available_height
      t.integer :screen_available_width
      t.string :url
      t.string :referrer
      t.string :title
      t.datetime :last_modified 
      t.datetime :created_at
    end

    add_index :visits, :site_id
    add_index :visits, :visitor_id
    add_index :visits, :timestamp
    add_index :visits, :created_at
    add_index :visits, :url
    add_index :visits, :cookies_enabled
    add_index :visits, :java_enabled
    add_index :visits, :last_modified
  end
end
