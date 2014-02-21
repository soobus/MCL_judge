class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :id
      t.string :title
      t.text :data
      t.string :img_url
      t.string :answer
      t.string :user_answer

      t.timestamps
    end
  end
end
