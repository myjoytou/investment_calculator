class CreateNavHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :nav_histories do |t|
      t.belongs_to :mutual_fund, index: true
      t.integer :scheme_code
      t.string :scheme_name
      t.decimal :net_asset_value
      t.decimal :repurchase_price
      t.decimal :sale_price
      t.datetime :date
      t.timestamps
    end
  end
end
