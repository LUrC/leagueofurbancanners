require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @admin_user = users(:one)
    @user = users(:two)
    @organizer = users(:three)
    @contentmanager = users(:four)
  end

  test "should set a default role of member on a user on save if there is no role set" do
    @user.role = nil
    @user.save
    assert_equal @user.role, "member"
  end

  test "should be able to answer if a user is an admin" do
    assert_equal @admin_user.admin?, true
    assert_equal @user.admin?, false
    assert_equal @organizer.admin?, false
    assert_equal @contentmanager.admin?, false
  end

  test "should treat organizer and admin roles as organizers" do
    assert_equal @admin_user.organizer?, true
    assert_equal @organizer.organizer?, true
    assert_equal @user.organizer?, false
    assert_equal @contentmanager.organizer?, false
  end

  test "should allow admins and contentmanagers to edit content" do
    assert_equal @admin_user.can_edit_content?, true
    assert_equal @organizer.can_edit_content?, false
    assert_equal @user.can_edit_content?, false
    assert_equal @contentmanager.can_edit_content?, true
  end

  test "should be able to set the current session user" do
    User.session_current_user = @user
    assert_equal User.session_current_user, @user
  end
end
