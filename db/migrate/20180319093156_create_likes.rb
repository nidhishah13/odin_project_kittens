class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.integer :liked_id
      t.integer :liker_id

      t.timestamps
    end
    add_index :likes, :liked_id
    add_index :likes, :liker_id
    add_index :likes, [:liked_id, :liker_id], unique: true
  end
end
