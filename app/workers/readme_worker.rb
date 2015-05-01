class ReadmeWorker
  include Sidekiq::Worker
  HTML_MEDIA_TYPE = 'application/vnd.github.VERSION.html'

  def perform(user_id)
    @user = User.find(user_id).no_reademe_repos.find_each(batch_size: 100) do |repo|
      logger.info "Readme `#{repo.full_name}` start"
      start_at = Time.now
      begin
        readme = repo.create_readme
      rescue ActiveRecord::RecordNotUnique
        next
      end
      readme.update_attribute :content, read_content(repo.full_name)
      logger.info "Readme `#{repo.full_name}` done, use #{ (Time.now - start_at).round(1) } sec"
    end
  end

  private

  def read_content(name)
    content = client.readme name, accept: HTML_MEDIA_TYPE
  end

  def client
    @client ||= Octokit::Client.new OAUTH_CONFIG[:github]
  end

end
