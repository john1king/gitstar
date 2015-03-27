require 'test_helper'

class RepoTest < ActiveSupport::TestCase

  test "create from github" do
    github_repo = {
      :id=>8514,
      :full_name=>"rails/rails",
      :html_url=>"https://github.com/rails/rails",
      :description=>"Ruby on Rails",
      :created_at=>"2008-04-11 02:19:47 UTC",
      :updated_at=>"2015-03-25 13:05:23 UTC",
      :starred_at=>"2015-01-11 03:22:38 UTC",
      :stargazers_count=>25389,
      :language=>"Ruby",
      :forks_count=>9972,
    }
    assert_difference 'Repo.count', 1 do
      Repo.create_from_github(github_repo)
    end
  end

end
