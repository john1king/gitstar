require 'test_helper'

class RepoTest < ActiveSupport::TestCase

  test "create from github" do
    github_repo = {
      :id=>1549395,
      :full_name=>"celluloid/celluloid",
      :html_url=>"https://github.com/celluloid/celluloid",
      :description=>"Actor-based concurrent object framework for Ruby",
      :created_at=>"2011-03-31 04:05:41 UTC",
      :updated_at=>"2015-02-12 03:25:45 UTC",
      :pushed_at=>"2015-01-11 03:22:38 UTC",
      :stargazers_count=>2686,
      :language=>"Ruby",
      :forks_count=>200,
    }
    assert_difference 'Repo.count', 1 do
      Repo.create_from_github(github_repo)
    end
  end

end
