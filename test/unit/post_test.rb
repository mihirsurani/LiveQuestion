require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "validate emptiness of post text" do
    post = Post.new
    assert !post.valid?
  end
end
