require 'test_helper'

class VoteAPostTest < ActionDispatch::IntegrationTest
  fixtures :all
  test "login and vote a post" do
    visit( root_path )
    fill_in 'username', :with => "mihir.surani"
    fill_in 'password', :with => "sriani"
    select 'user', :from => "permission"
    click_button("Login")
    assert (current_path == "/posts")
    click_link("show#{posts(:onepost).id}")
    count = Vote.count
    click_link("Vote Post")
    count_new = Vote.count
    assert (count_new == count+1)
  end
end
