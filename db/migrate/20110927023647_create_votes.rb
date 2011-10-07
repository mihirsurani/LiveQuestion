class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :posts
      t.references :users

      t.timestamps
    end
  end
end
