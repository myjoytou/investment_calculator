class AddIndexToDateAndSchemeCodeToNavHistories < ActiveRecord::Migration[5.0]
  def change
    add_index :nav_histories, :scheme_code
    add_index :nav_histories, :date
  end
end
