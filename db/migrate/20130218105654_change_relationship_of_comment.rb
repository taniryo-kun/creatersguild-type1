class ChangeRelationshipOfComment < ActiveRecord::Migration
  def up
    rename_column :comments, :workstage_id, :commentable_id
    add_column :comments, :commentable_type, :string
    Comment.update_all ["commentable_type = ?","Workstage"]
  end

  def down
    rename_column :comments, :commentable_id, :workstage_id
    remove_column :comments, :commentable_type
  end
end
