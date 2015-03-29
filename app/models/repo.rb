require 'elasticsearch/model'

class Repo < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :stars, -> { where(active: true).order(starred_at: :desc) }
  has_many :users, through: :stars
  has_one :readme

  GITHUB_COLUMNS = %i(
    full_name
    description
    html_url
    language
    forks_count
    stargazers_count
    created_at
    updated_at
  )

  def as_indexed_json(options={})
    as_json(
      only: [:full_name, :description]
    )
  end

  def self.search(query, options = {})
    options[:page] ||= 1
    options[:per_page] ||= 30
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['full_name^10', 'description']
          }
        },
        size: options[:per_page],
        from: (options[:page] - 1) * options[:per_page]
      }
    )
  end

  def self.create_from_github(github_repo)
    find_or_create_by!(id: github_repo[:id]) do |repo|
      GITHUB_COLUMNS.each do |column|
        repo[ensure_column_name(column)] = github_repo[column]
      end
    end
  end

  def self.ensure_column_name(name)
    column = "origin_#{name}"
    column.in?(column_names) ? column.to_sym : name
  end

  def owner
    full_name.split('/')[0]
  end

  def name
    full_name.split('/')[1]
  end

end
