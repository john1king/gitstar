class CreateJoinTableTagStar < ActiveRecord::Migration
  def change
    create_join_table :tags, :stars do |t|
      t.index [:tag_id, :star_id]
    end
  end
end
