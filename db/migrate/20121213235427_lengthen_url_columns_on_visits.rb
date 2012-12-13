class LengthenUrlColumnsOnVisits < ActiveRecord::Migration
  def up
    change_column :visits, :url, :text
    change_column :visits, :referrer, :text
    change_column :visits, :previous_page, :text
  end

  def down
    change_column :visits, :url, :string
    change_column :visits, :referrer, :string
    change_column :visits, :previous_page, :string
  end
end
