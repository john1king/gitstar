class ReadmeWorker
  include Sidekiq::Worker
  HTML_MEDIA_TYPE = 'application/vnd.github.VERSION.html'

  def perform(repo_id)
    repo = Repo.find(repo_id)
    return if repo.readme && !repo.readme.is_loading
    begin
      readme = repo.create_readme is_loading: true
    rescue  ActiveRecord::RecordNotUnique
      return
    end
    readme.update_attribute :content, read_content(repo.full_name)
  end

  private

  def read_content(name)
    content = Octokit.readme name, accept: HTML_MEDIA_TYPE
  end

end
