require 'test_helper'

class AdminDeleteUserAccountTest < ActionDispatch::IntegrationTest
  fixtures :all
  test "admin logs in and creates another admin account" do
    visit( root_path )
    fill_in 'username', :with => "mihiradmin"
    fill_in 'password', :with => "mihir123"
    select 'admin', :from => "permission"
    click_button("Login")
    assert (current_path == "/users/#{users(:adminacc).id}")
    click_link("Users")
    assert (current_path == "/users")
    click_link("destroy#{users(:one).id}")
    assert (current_path == "/users")
  end
end
