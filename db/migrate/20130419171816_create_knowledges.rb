class CreateKnowledges < ActiveRecord::Migration
  def change
    create_table :knowledges do |t|
      t.string :section
      t.string :title
      t.string :ref_work
      t.string :product_url
      t.string :category
      t.string :knowledge_img
      t.timestamps
    end
  end
end
