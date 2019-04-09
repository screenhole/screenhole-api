class RemoveCountryCodeFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :country_code, :string
  end
end
