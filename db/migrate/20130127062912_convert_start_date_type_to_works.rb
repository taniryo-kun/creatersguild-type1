class ConvertStartDateTypeToWorks < ActiveRecord::Migration
  def up
  	add_column :works, :start_time, :date
  end

  def down
  	remove_column :works, :start_time, :string
  end
end
