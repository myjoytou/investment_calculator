class CreateMutualFunds < ActiveRecord::Migration[5.0]
  def change
    create_table :mutual_funds do |t|
      t.string :name
      t.timestamps
    end
  end
end
