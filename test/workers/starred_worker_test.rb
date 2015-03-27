require 'test_helper'

class StarredWorkerTest < ActiveSupport::TestCase

  def make_worker(stars)
    worker = StarredWorker.new
    worker.stubs(:last_starred).returns(stars.first)
    worker.stubs(:starred_count).returns(stars.size)
    worker.stubs(:each).multiple_yields(*stars.map{|s| [s]})
    worker.stubs(:fetch_readme).returns(nil)
    worker
  end

  def make_star(id, name, starred_at = '2015-01-01 00:00:00 UTC')
    {
      repo: {
        id: id,
        full_name: "#{name}/#{name}",
        html_url: "https://github.com/#{name}/#{name}",
        description: name,
        created_at: "2008-04-11 02:19:47 UTC",
        updated_at: "2015-03-25 13:05:23 UTC",
        stargazers_count: 1000,
        language: "Ruby",
        forks_count: 1000,
      },
      starred_at: starred_at,
    }
  end

  test 'user has not star' do
    worker = make_worker([])
    refute worker.perform(users(:no_star).id, 'foo')
  end

  test 'fetch stars' do
    worker = make_worker([
      make_star(100, 'rails'),
      make_star(101, 'sinatra'),
      make_star(102, 'unicorn'),
    ])
    assert_difference 'Star.count', 3 do
      assert worker.perform(users(:no_star).id, 'foo')
    end
    assert_equal 3, users(:no_star).reload.stars_count
  end

  test 'fetch stars and updated' do
    worker = make_worker([
      make_star(repos(:ruby).id, 'ruby'),
      make_star(repos(:python).id, 'python'),
      make_star(repos(:js).id, 'javascript'),
      make_star(4, 'go'),
    ])
    assert_difference 'Star.count', 2 do
      assert_difference 'Repo.count', 1 do
        assert worker.perform(users(:has_stars).id, 'foo')
      end
    end
    assert_equal 4, users(:has_stars).reload.stars_count
  end

  test 'fetch stars but not updated' do
    worker = make_worker([
      make_star(repos(:ruby).id, 'ruby', '2015-01-01 00:00:01'),
      make_star(repos(:python).id, 'python', '2015-01-01 00:00:00'),
    ])
    assert_no_difference 'Star.count' do
      refute worker.perform(users(:has_stars).id, 'foo')
    end
  end

  test 'deleted star' do
    worker = make_worker([
      make_star(repos(:ruby).id, 'ruby', '2015-01-01 00:00:01'),
    ])
    assert_difference 'Star.where(active: true).count', -1 do
      assert_difference 'Star.where(active: false).count', 1 do
        assert worker.perform(users(:has_stars).id, 'foo')
      end
    end
  end

end

