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

  def self.search(query, user_id, options = {})
    options[:page] ||= 1
    options[:per] ||= 30
    query_opts = {
      multi_match: {
        query: query,
        fields: ['repo.name^10', 'repo.owner', 'repo.description']
      }
    }
    term_opts = {
      'user.id' => user_id
    }
    term_opts['tags.name'] = options[:tag] if options[:tag]
    __elasticsearch__.search(
      {
        query: {
          filtered: {
            query: query_opts,
            filter: {
              term: term_opts
            }
          }
        },
        highlight: {
          fields: {
            'repo.owner' => {},
            'repo.name' => {},
            'repo.description' => {},
          }
        },
        size: options[:per],
        from: (options[:page] - 1) * options[:per]
      }
    )
  end

end
