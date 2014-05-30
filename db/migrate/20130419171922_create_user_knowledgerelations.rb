class CreateUserKnowledgerelations < ActiveRecord::Migration
  def change
    create_table :user_knowledgerelations do |t|
      t.integer :user_id
      t.integer :knowledge_id

      t.timestamps
    end
  end
end
