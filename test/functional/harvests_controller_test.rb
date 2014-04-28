require 'test_helper'

class HarvestsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @harvest = harvests(:one)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:harvests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create harvest" do
    assert_difference('Harvest.count') do
      post :create, harvest: { amount_harvested: @harvest.amount_harvested, canners_needed: @harvest.canners_needed, date: @harvest.date, description: @harvest.description, fruit_tree_id: @harvest.fruit_tree_id, harvesters_needed: @harvest.harvesters_needed, leader_id: @harvest.leader_id, notes: @harvest.notes }
    end

    assert_redirected_to harvest_path(assigns(:harvest))
  end

  test "should show harvest" do
    get :show, id: @harvest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @harvest
    assert_response :success
  end

  test "should update harvest" do
    put :update, id: @harvest, harvest: { amount_harvested: @harvest.amount_harvested, canners_needed: @harvest.canners_needed, date: @harvest.date, description: @harvest.description, fruit_tree_id: @harvest.fruit_tree_id, harvesters_needed: @harvest.harvesters_needed, leader_id: @harvest.leader_id, notes: @harvest.notes }
    assert_redirected_to harvest_path(assigns(:harvest))
  end

  test "should destroy harvest" do
    assert_difference('Harvest.count', -1) do
      delete :destroy, id: @harvest
    end

    assert_redirected_to harvests_path
  end
end
