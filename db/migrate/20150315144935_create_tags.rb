class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :user_id
      t.integer :stars_count, default: 0
      t.timestamp
    end
  end
end
