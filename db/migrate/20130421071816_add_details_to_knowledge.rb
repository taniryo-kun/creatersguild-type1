class AddDetailsToKnowledge < ActiveRecord::Migration
  def change
    add_column :knowledges, :work_id, :integer
  end
end
