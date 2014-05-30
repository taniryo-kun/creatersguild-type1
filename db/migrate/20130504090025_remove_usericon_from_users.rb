class RemoveUsericonFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :usericon
  end
end
