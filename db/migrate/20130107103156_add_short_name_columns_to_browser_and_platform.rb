class AddShortNameColumnsToBrowserAndPlatform < ActiveRecord::Migration
  def change
    add_column :browsers, :short_name, :string
    add_column :platforms, :short_name, :string
  end
end
