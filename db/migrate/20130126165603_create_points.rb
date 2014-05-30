class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :workstage_id	#工程識別子
      t.float :coordinateX		#x座標
      t.float :coordinateY		#y座標
      t.timestamps
    end
  end
end
