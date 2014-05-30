class CreateIdeaWorkRelations < ActiveRecord::Migration
  def change
    create_table :idea_work_relations do |t|
      t.integer :idea_id
      t.integer :work_id

      t.timestamps
    end
  end
end
