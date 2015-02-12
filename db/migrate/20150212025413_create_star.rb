class CreateStar < ActiveRecord::Migration
  def change
    create_table :stars do |t|
      t.integer :user_id
      t.integer :repo_id
      t.datetime :pushed_at, index: true
    end
    add_index :stars, [:user_id, :repo_id], unique: true
  end
end
