require 'test_helper'

class CannotVoteToHisOwnPostTest < ActionDispatch::IntegrationTest
  fixtures :all
  test "cannot vote to own post" do
    visit( root_path )
    fill_in 'username', :with => "ani"
    fill_in 'password', :with => "ani123"
    select 'user', :from => "permission"
    click_button("Login")
    assert (current_path == "/posts")
    click_link("Create Post")
    assert (current_path == "/posts/new")
    fill_in 'post_posttext', :with => "Mihir keeps posting things.... "
    click_button("Create Post")
    assert (current_path == "/posts/#{find_field("postid").value()}")
    count = Vote.count
    click_link("Vote Post")
    count_new = Vote.count
    assert (count_new == count)
  end
end
