class CreateOnlineVisitorCounts < ActiveRecord::Migration
  def change
    create_table :online_visitor_counts do |t|
      t.integer :site_id
      t.integer :count
      t.datetime :created_at
    end

    add_index :online_visitor_counts, :site_id
    add_index :online_visitor_counts, :created_at
  end
end
