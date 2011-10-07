require 'test_helper'

class CreatePostAfterLoginTest < ActionDispatch::IntegrationTest
  fixtures :all
  test "create new post after login from home page" do
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
  end

end
