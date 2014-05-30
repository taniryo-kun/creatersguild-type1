class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :idea
      t.integer :user_id

      t.timestamps
    end
  end
end
