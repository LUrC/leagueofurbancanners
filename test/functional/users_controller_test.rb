require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @user = users(:one)
    sign_in @user
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: { email: 'foo@foo.com' }
    assert_redirected_to people_path
  end

end

