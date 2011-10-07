require 'test_helper'

class AdminLogsCreatesAdminTest < ActionDispatch::IntegrationTest
  fixtures :all
  test "admin logs in and creates another admin account" do
    visit( root_path )
    fill_in 'username', :with => "mihiradmin"
    fill_in 'password', :with => "mihir123"
    select 'admin', :from => "permission"
    click_button("Login")
    assert (current_path == "/users/#{users(:adminacc).id}")
    click_link("Create Admin")
    assert (current_path == "/users/new")
    fill_in 'user_userid', :with => "aniadmin"
    fill_in 'user_pwd', :with => "admin123"
    fill_in 'conf_pass', :with => "admin123"
    fill_in 'user_name', :with => "Ani Admin"
    fill_in 'user_email', :with => "aniadmin@gmail.com"
    click_button("Create Account")
    assert (current_path == "/users/#{users(:adminacc).id}")
  end
end
