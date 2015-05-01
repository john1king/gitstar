class Star < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user, counter_cache: true
  belongs_to :repo, counter_cache: :stargazers_count
  has_many :stars_tags
  has_many :tags, through: :stars_tags

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :description, type: :string
      indexes :repo do
        indexes :owner, type: :string
        indexes :name, type: :string
        indexes :description, type: :string
      end
      indexes :user do
        indexes :id, type: :integer
      end
      indexes :tags do
        indexes :name, type: :string, index: :not_analyzed
      end
    end
  end

  def as_indexed_json(options={})
    as_json(
      only: [:description],
      include: {
        repo: {
          only: [:id, :description],
          methods: [:name, :owner]
        },
        user: {
          only: [:id]
        },
        tags: {
          only: [:id, :name]
        }
      }
    )
  end

  def self.search(user_id, query, options = {})
    __elasticsearch__.search(
      {
        query: query_and_filter_by(
          query,
          'user.id' => user_id,
          'tags.name' => options[:tag],
        ),
        highlight: {
          fields: {
            'repo.owner' => {},
            'repo.name' => {},
            'repo.description' => {},
          }
        }
      }.merge search_result_page(options)
    )
  end

  def self.aggregate(user_id, query)
    result = __elasticsearch__.search({
      query: query_and_filter_by(query, 'user.id' => user_id),
      aggs: {
        tag_counts: {
          terms: {
            field: 'tags.name'
          }
        }
      }
    })
    result.response['aggregations']['tag_counts']['buckets']
  end

  def self.search_result_page(options = {})
    page = options[:page] || 1
    per = options[:per] || 30
    {size: per, from: (page - 1) * per}
  end

  def self.query_and_filter_by(query, filters = {})
    {
      filtered: {
        query: {
          multi_match: {
            query: query,
            fields: ['repo.name^10', 'repo.owner', 'repo.description']
          }
        },
        filter: {
          term: filters.select {|k, v| v.present? }
        }
      }
    }
  end

end
