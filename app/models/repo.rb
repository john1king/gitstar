class Repo < ActiveRecord::Base

  GITHUB_KEYS = [
    :full_name,
    :description,
    :html_url,
    :language,
    :forks_count,
    :stargazers_count,
  ]

  def self.create_from_github(github_repo)
    find_or_create_by!(id: github_repo[:id]) do |repo|
      GITHUB_KEYS.each { |key| repo[key] = github_repo[key] }
      repo.repo_created_at = github_repo[:created_at]
      repo.repo_updated_at = github_repo[:updated_at]
    end
  end
end
