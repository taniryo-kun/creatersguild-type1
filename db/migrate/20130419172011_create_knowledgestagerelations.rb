class CreateKnowledgestagerelations < ActiveRecord::Migration
  def change
    create_table :knowledgestagerelations do |t|
      t.integer :workstage_id
      t.integer :knowledge_id

      t.timestamps
    end
  end
end
