class CreateReadmes < ActiveRecord::Migration
  def change
    create_table :readmes do |t|
      t.integer :repo_id, null: false
      t.text :content
      t.boolean :is_loading, default: false
      t.timestamp
    end
    add_index :readmes, :repo_id,  unique: true
  end
end
