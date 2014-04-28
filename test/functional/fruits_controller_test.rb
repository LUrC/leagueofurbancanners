require 'test_helper'

class FruitsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @fruit = fruits(:one)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fruits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fruit" do
    assert_difference('Fruit.count') do
      post :create, fruit: { name: @fruit.name, season_end_month: @fruit.season_end_month, season_end_day: @fruit.season_end_day, season_start_month: @fruit.season_start_month, season_start_day: @fruit.season_start_day }
    end

    assert_redirected_to fruit_path(assigns(:fruit))
  end

  test "should show fruit" do
    get :show, id: @fruit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fruit
    assert_response :success
  end

  test "should update fruit" do
    put :update, id: @fruit, fruit: { name: @fruit.name, season_end_month: @fruit.season_end_month, season_end_day: @fruit.season_end_day, season_start_month: @fruit.season_start_month, season_start_day: @fruit.season_start_day }
    assert_redirected_to fruit_path(assigns(:fruit))
  end

  test "should destroy fruit" do
    assert_difference('Fruit.count', -1) do
      delete :destroy, id: @fruit
    end

    assert_redirected_to fruits_path
  end
end
