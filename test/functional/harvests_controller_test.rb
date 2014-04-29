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

  test "should get harvests for person if person param present" do
    person = people(:personone)
    get :index, :person_id => person
    assert_not_nil assigns(:person)
    assert_equal(person.upcoming_harvests, assigns(:upcoming_harvests))
    assert_equal(person.past_harvests, assigns(:past_harvests))
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

  test "should get reminder" do
    get :reminder, id: @harvest
    assert_response :success
    assert_not_nil assigns(:harvest)
  end

  test "should send reminder" do
    post :send_reminder, id: @harvest, :message => 'Foo'
    assert_equal 'Foo', assigns(:message)
    assert_equal @user.person.id, assigns(:from).id
    assert !ActionMailer::Base.deliveries.empty?
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
