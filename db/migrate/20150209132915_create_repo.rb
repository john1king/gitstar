class CreateRepo < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :description, limit: 1000
      t.string :full_name
      t.string :html_url
      t.string :language
      t.integer :forks_count
      t.integer :origin_stargazers_count
      t.datetime :origin_created_at
      t.datetime :origin_updated_at
      t.integer :stargazers_count, default: 0

      t.timestamps null: false
    end
  end
end
