class Repo < ActiveRecord::Base

  REPO_FIELDS = [
    :id,
    :description,
    :full_name,
    :html_url,
    :language,
    :forks_count,
    :stargazers_count,
  ]

  def self.create_from_github(github_repo)
    attrs = {}
    REPO_FIELDS.each do |key|
      attrs[key] = github_repo[key]
    end
    [:created_at, :updated_at].each do |key|
      attrs[:"repo_#{key}"] = github_repo[key]
    end
    repo = find_or_initialize_by(id: attrs[:id])
    repo.update_attributes(attrs)
  end
end
