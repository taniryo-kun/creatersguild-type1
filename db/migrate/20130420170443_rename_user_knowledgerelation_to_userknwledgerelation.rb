class RenameUserKnowledgerelationToUserknwledgerelation < ActiveRecord::Migration
  def change
  	rename_table(:user_knowledgerelations, :userknowledgerelations)
  end
end
