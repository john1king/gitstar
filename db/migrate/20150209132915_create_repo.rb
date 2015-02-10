class CreateRepo < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :description, limit: 1000
      t.string :full_name
      t.string :html_url
      t.string :language
      t.integer :forks_count
      t.integer :stargazers_count
      t.time :repo_created_at
      t.time :repo_updated_at

      t.timestamp
    end
  end
end
