class AddAllowedHostsColumnToSites < ActiveRecord::Migration
  def change
    add_column :sites, :allowed_hosts, :string, array: true
  end
end
