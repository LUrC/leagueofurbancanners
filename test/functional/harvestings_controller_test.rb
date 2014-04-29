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

  test "should get harvestings for harvest when nested under harvest" do
    get :index, :harvest_id => @harvesting.harvest
    assert_response :success
    assert_equal @harvesting.harvest.harvestings, assigns(:harvestings)
  end

  test "should get harvestings for person when nested under person" do
    get :index, :person_id => @harvesting.harvester
    assert_response :success
    assert_equal @harvesting.harvester.harvestings, assigns(:harvestings)
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

  test "should redirect to new harvesting page if param commit asks to add another on action create" do
    post :create, :harvest_id => @harvesting.harvest, harvesting: { harvest_id: @harvesting.harvest_id, hours: @harvesting.hours, harvester_id: @harvesting.harvester_id }, :commit => "Log Work and Add Another"
    assert_redirected_to new_harvest_harvesting_path(assigns(:harvest))
  end

  test "should redirect to harvest page if param commit asks to log work" do
    post :create, :harvest_id => @harvesting.harvest, harvesting: { harvest_id: @harvesting.harvest_id, hours: @harvesting.hours, harvester_id: @harvesting.harvester_id }, :commit => "Log Work"
    assert_redirected_to assigns(:harvest)
  end

  test "should show harvesting" do
    get :show, :harvest_id => @harvesting.harvest, id: @harvesting
    assert_response :success
  end

  test "should get edit" do
    get :edit, :harvest_id => @harvesting.harvest, id: @harvesting
    assert_response :success
  end

  test "should get reminder" do
    get :reminder, :harvest_id => @harvesting.harvest, harvesting_id: @harvesting
    assert_response :success
    assert_not_nil assigns(:harvesting)
  end

  test "should send reminder" do
    post :send_reminder, :harvest_id => @harvesting.harvest, harvesting_id: @harvesting, :message => 'Foo'
    assert_equal 'Foo', assigns(:message)
    assert_equal @user.person.id, assigns(:from).id
    assert !ActionMailer::Base.deliveries.empty?
  end

  test "should update harvesting" do
    put :update, :harvest_id => @harvesting.harvest, id: @harvesting, harvesting: { harvest_id: @harvesting.harvest_id, hours: @harvesting.hours, harvester_id: @harvesting.harvester_id }
    assert_redirected_to harvest_path(assigns(:harvesting))
  end

  test "should redirect to new harvesting page if param commit asks to add another on action update" do
    put :update, :harvest_id => @harvesting.harvest, id: @harvesting, harvesting: { harvest_id: @harvesting.harvest_id, hours: @harvesting.hours, harvester_id: @harvesting.harvester_id }, :commit => "Log Work and Add Another"
    assert_redirected_to new_harvest_harvesting_path(assigns(:harvest))
  end

  test "should destroy harvesting" do
    assert_difference('Harvesting.count', -1) do
      delete :destroy, :harvest_id => @harvesting.harvest, id: @harvesting
    end

    assert_redirected_to harvest_path(@harvesting.harvest)
  end
end
