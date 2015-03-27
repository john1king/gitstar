require 'test_helper'

class TagTest < ActiveSupport::TestCase

  test 'order acitve stars' do
    assert_equal [repos(:js), repos(:python)], tags(:script).stars.map(&:repo)
  end

  test 'unstar tagged repo' do
    users(:has_stars).unstar_repo(repos(:ruby))
    assert_equal 1, tags(:has_stars).stars_count
  end

  test 'valid tag name' do
    ['f', 'foo', 'foo bar', '标签', 'x'*29].each do |name|
      tag = Tag.new(name: name)
      assert tag.valid?
    end
  end

  test 'invalid tag name' do
    ['', 'foo,bar', 'x'*31].each do |name|
      tag = Tag.new(name: name)
      refute tag.valid?
    end
  end
end
