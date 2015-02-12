class StarredWorker
  include Sidekiq::Worker

  STARRED_MEDIA_TYPE = 'application/vnd.github.v3.star+json'

  def perform(user_id, access_token)
    @user = User.find(user_id)
    @client = Octokit::Client.new(access_token: access_token)
    return unless updated?
    list_starred(100)
    paginate @client.last_response do |data|
      data.each { |star|
        repo = Repo.create_from_github(star[:repo])
        @user.star_repo(repo, star[:starred_at])
      }
    end
  end

  private

  def list_starred(pre_page=30)
    @client.starred(nil, per_page: pre_page, accept: STARRED_MEDIA_TYPE)
  end

  def paginate(response)
    options = { headers: { accept: STARRED_MEDIA_TYPE } }
    loop do
      yield response.data
      break if response.rels[:next].nil?
      response = response.rels[:next].get options
    end
  end

  def updated?
    last_github_star = list_starred(1).first
    last_star = @user.stars.order(:starred_at).last
    starred_count = /\bpage=(\d+)/.match(@client.last_response.rels[:last].href)[1]
    !(@user.stars_count.to_s == starred_count &&
      last_star.id == last_github_star[:repo][:id] &&
      last_star.starred_at == last_github_star[:starred_at])
  end

end
