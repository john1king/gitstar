class StarredWorker
  include Sidekiq::Worker

  STARRED_MEDIA_TYPE = 'application/vnd.github.v3.star+json'

  def perform(user_id, access_token)
    @user = User.find(user_id)
    @access_token = access_token
    return false if not_updated?
    last_updated = DateTime.now
    each(100) do |star|
      repo = Repo.create_from_github(star[:repo])
      @user.star_repo(repo, star[:starred_at], last_updated)
    end
    @user.unstar_deleted_repo(last_updated)
    ReadmeWorker.perform_async(user_id)
    true
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
    star = @user.stars.first
    @user.stars_count == starred_count && (
      # 数据正确的情况下，count 相等就不会只有其中一者为 nil，下面一行的判断可删除
      (star.nil? && last_starred.nil?) ||
        (star.present? && last_starred.present? &&
         star.repo.id == last_starred[:repo][:id] &&
         star.starred_at == last_starred[:starred_at])
    )
  end

  def last_starred
    return @last_starred if defined? @last_starred
    last_starred_and_total_count
    @last_starred
  end

  def starred_count
    return @starred_count if defined? @starred_count
    last_starred_and_total_count
    @starred_count
  end

  def last_starred_and_total_count
    @last_starred = list_starred_batch(1).first
    last_page = client.last_response.rels[:last]
    if last_page
      @starred_count = /\bpage=(\d+)/.match(last_page.href)[1].to_i
    else
      @starred_count = client.last_response.data.size
    end
  end

end
