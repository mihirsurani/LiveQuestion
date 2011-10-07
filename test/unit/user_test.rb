require 'test_helper'

class UserTest < ActiveSupport::TestCase
 fixtures :users

 test "validate userid presence" do
  user = User.new
  assert !user.valid?
 end

test "uniqueness of userid" do
  user = User.new
  user.userid = users(:one).userid
  user.pwd = "onetwothree"
  assert !user.valid?
end

test "user authentication" do
  user = User.new
  user.userid = "mihir"
  user.pwd = "mihir123"
  user.permission = "user"
  user.save
  User.authenticate(user.userid,user.pwd,user.permission)
end

end
