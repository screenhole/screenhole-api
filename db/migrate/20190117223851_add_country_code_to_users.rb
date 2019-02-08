class AddCountryCodeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :country_code, :string, limit: 2
  end
end
