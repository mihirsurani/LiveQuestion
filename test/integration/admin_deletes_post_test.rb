require 'test_helper'

class AdminDeletesPostTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "admin logs in and deletes post" do
    visit( root_path )
    fill_in 'username', :with => "mihiradmin"
    fill_in 'password', :with => "mihir123"
    select 'admin', :from => "permission"
    click_button("Login")
    assert (current_path == "/users/#{users(:adminacc).id}")
    click_link("Posts")
    assert (current_path == "/posts")
    click_link("destroy#{posts(:onepost).id}")
    assert (current_path == "/posts")
  end
end
