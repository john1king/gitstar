class StarredWorker
  include Sidekiq::Worker

  def perform(user_id, access_token)
    client = Octokit::Client.new(access_token: access_token)
    client.starred
    last_response = client.last_response
    loop do
      last_response.data.each { |repo|
        Repo.create_from_github(repo)
      }
      break if last_response.rels[:next].href.nil?
      last_response = last_response.rels[:next].get
    end
  end

end
