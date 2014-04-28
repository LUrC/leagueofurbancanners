require 'test_helper'

class HarvestingsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @harvesting = harvestings(:one)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index, :harvest_id => @harvesting.harvest
    assert_response :success
    assert_not_nil assigns(:harvestings)
  end

  test "should get new" do
    get :new, :harvest_id => @harvesting.harvest
    assert_response :success
  end

  test "should create harvesting" do
    assert_difference('Harvesting.count') do
      post :create, :harvest_id => @harvesting.harvest, harvesting: { harvest_id: @harvesting.harvest_id, hours: @harvesting.hours, harvester_id: @harvesting.harvester_id }
    end

    assert_redirected_to harvest_path(assigns(:harvesting).harvest)
  end

  test "should show harvesting" do
    get :show, :harvest_id => @harvesting.harvest, id: @harvesting
    assert_response :success
  end

  test "should get edit" do
    get :edit, :harvest_id => @harvesting.harvest, id: @harvesting
    assert_response :success
  end

  test "should update harvesting" do
    put :update, :harvest_id => @harvesting.harvest, id: @harvesting, harvesting: { harvest_id: @harvesting.harvest_id, hours: @harvesting.hours, harvester_id: @harvesting.harvester_id }
    assert_redirected_to harvest_path(assigns(:harvesting))
  end

  test "should destroy harvesting" do
    assert_difference('Harvesting.count', -1) do
      delete :destroy, :harvest_id => @harvesting.harvest, id: @harvesting
    end

    assert_redirected_to harvest_path(@harvesting.harvest)
  end
end
