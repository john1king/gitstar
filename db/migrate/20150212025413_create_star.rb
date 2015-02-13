class CreateStar < ActiveRecord::Migration
  def change
    create_table :stars do |t|
      t.integer :user_id
      t.integer :repo_id
      t.datetime :starred_at, index: true
      t.string :description, default: '', null: false, limit: 1000
      t.boolean :active, default: true
    end
    add_index :stars, [:user_id, :repo_id], unique: true
  end
end
