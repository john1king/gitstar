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
    content = Octokit.readme repo.full_name, accept: HTML_MEDIA_TYPE
    readme.update_attribute :content, content
  end

  private

end
