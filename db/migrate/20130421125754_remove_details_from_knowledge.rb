class RemoveDetailsFromKnowledge < ActiveRecord::Migration
  def up
    remove_column :knowledges, :work_id
  end

  def down
    add_column :knowledges, :work_id, :integer
  end
end
