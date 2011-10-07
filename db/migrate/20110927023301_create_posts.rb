class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :userid
      t.text :posttext
      t.references :posts
      t.integer :weight

      t.timestamps
    end
  end
end
