class AddBrowserWidthColumnsToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :browser_inner_width, :integer
    add_column :visits, :browser_inner_height, :integer
  end
end
