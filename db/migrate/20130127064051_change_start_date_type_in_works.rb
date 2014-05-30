class ChangeStartDateTypeInWorks < ActiveRecord::Migration
  def up
  	remove_column :works, :start_date, :string
  	add_column :works, :start_date, :date
  end

  def down
  end
end
