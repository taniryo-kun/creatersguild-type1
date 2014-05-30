class CreateTools < ActiveRecord::Migration
  def change
    create_table :tools do |t|
      t.string :section
      t.string :title
      t.string :product_url
      t.timestamps
    end
  end
end
