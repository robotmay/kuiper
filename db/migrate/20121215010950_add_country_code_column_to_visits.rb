class AddCountryCodeColumnToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :country_code, :string, limit: 2
    add_index :visits, :country_code
  end
end
