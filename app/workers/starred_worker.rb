class StarredWorker
  include Sidekiq::Worker

  def perform(user_id, access_token)
    user = User.find(user_id)
    client = Octokit::Client.new(access_token: access_token)
    client.starred
    last_response = client.last_response
    loop do
      last_response.data.each { |github_repo|
        repo = Repo.create_from_github(github_repo)
        user.star_repo(repo, github_repo[:starred_at])
      }
      break if last_response.rels[:next].nil?
      last_response = last_response.rels[:next].get
    end
  end

end
