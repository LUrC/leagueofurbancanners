require 'test_helper'

class CanningsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @canning = cannings(:one)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cannings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create canning" do
    assert_difference('Canning.count') do
      post :create, canning: { canner_id: @canning.canner_id, canning_session_id: @canning.canning_session_id, hours: @canning.hours }
    end

    assert_redirected_to canning_path(assigns(:canning))
  end

  test "should show canning" do
    get :show, id: @canning
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @canning
    assert_response :success
  end

  test "should update canning" do
    put :update, id: @canning, canning: { canner_id: @canning.canner_id, canning_session_id: @canning.canning_session_id, hours: @canning.hours }
    assert_redirected_to canning_path(assigns(:canning))
  end

  test "should destroy canning" do
    assert_difference('Canning.count', -1) do
      delete :destroy, id: @canning
    end

    assert_redirected_to cannings_path
  end
end
