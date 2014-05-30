class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :type
      t.string :image
      t.string :parent_type
      t.integer :parent_id

      t.timestamps
    end
  end
end
