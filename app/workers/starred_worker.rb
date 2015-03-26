class StarredWorker
  include Sidekiq::Worker

  STARRED_MEDIA_TYPE = 'application/vnd.github.v3.star+json'

  def perform(user_id, access_token)
    @user = User.find(user_id)
    @access_token = access_token
    return if not_updated?
    last_updated = DateTime.now
    each(100) do |star|
      repo = Repo.create_from_github(star[:repo])
      @user.star_repo(repo, star[:starred_at], last_updated)
      fetch_readme repo.id
    end
    @user.unstar_deleted_repo(last_updated)
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: @access_token)
  end

  def list_starred_batch(per_page=30)
    client.starred(nil, per_page: per_page, accept: STARRED_MEDIA_TYPE)
  end

  def each(per_page, &blk)
    list_starred_batch(per_page)
    paginate client.last_response do |data|
      data.each(&blk)
    end
  end

  def paginate(response)
    options = { headers: { accept: STARRED_MEDIA_TYPE } }
    loop do
      yield response.data
      break if response.rels[:next].nil?
      response = response.rels[:next].get options
    end
  end

  def not_updated?
    github_star = list_starred_batch(1).first
    star = @user.stars.first
    # 注意 starred_count 必须在 list_starred_batch(1) 之后调用
    @user.stars_count == starred_count &&
      # 数据正确的情况下，count 相等就不会只有其中一者为 nil，下面一行的判断可删除
      (star.nil? && github_star.nil?) ||
        (star.present? && github_star.present? &&
         star.id == github_star[:repo][:id] &&
         star.starred_at == github_star[:starred_at])
  end

  def starred_count
    return @starred_count if defined? @starred_count
    last_page = @client.last_response.rels[:last]
    if last_page
      /\bpage=(\d+)/.match(last_page.href)[1].to_i
    else
      @client.last_response.data.size
    end
  end

  def fetch_readme(repo_id)
    ReadmeWorker.perform_async(repo_id)
  end

end
