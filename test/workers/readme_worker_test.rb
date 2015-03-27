require 'test_helper'

class ReadmeWorkerTest < ActiveSupport::TestCase

  test "fetch readme" do
    worker = ReadmeWorker.new
    worker.expects(:read_content).returns('foo')
    worker.perform(repos(:ruby).id)
    assert_equal 'foo', Readme.find_by(repo: repos(:ruby)).content
  end

  test "skip fetch if readme is loaded" do
    worker = ReadmeWorker.new
    worker.expects(:read_content).never
    worker.perform(repos(:python).id)
  end

  test "skip fetch if readme is loading" do
    worker = ReadmeWorker.new
    worker.expects(:read_content).never
    worker.perform(repos(:js).id)
  end

end

