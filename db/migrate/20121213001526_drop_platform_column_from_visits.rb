class DropPlatformColumnFromVisits < ActiveRecord::Migration
  def up
    remove_column :visits, :platform
  end

  def down
    add_column :visits, :platform, :string
  end
end
