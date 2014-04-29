require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.set_default_stub(
      [
        {
          'latitude'     => 40.7143528,
          'longitude'    => -74.0059731,
          'address'      => 'New York, NY, USA',
          'state'        => 'New York',
          'state_code'   => 'NY',
          'country'      => 'United States',
          'country_code' => 'US'
        }
      ]
    )

    @person = people(:personone)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:people)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person" do
    assert_difference('Person.count') do
      post :create, person: { email: @person.email, first_name: @person.first_name, last_name: @person.last_name, phone: @person.phone}
    end

    assert_redirected_to person_path(assigns(:person))
  end

  test "should show person" do
    get :show, id: @person
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @person
    assert_response :success
  end

  test "should get site chooser" do
    get :site_chooser, id: @person
    assert_response :success
    assert_not_nil(assigns(:choices))
    assert_not_nil(assigns(:mapped))
    assert_equal(@person.id, assigns(:mapped).first.id)
  end

  test "should accept address parameter in site chooser" do
    get :site_chooser, id: @person, :address => '19 Corporal Burns Road, Cambridge MA 02138'
    assert_response :success
    assert_not_nil(assigns(:choices))
    assert_not_nil(assigns(:address))
    assert_not_nil(assigns(:mapped))
    assert_not_equal(@person.id, assigns(:mapped).first.id)
  end

  test "should update person" do
    put :update, id: @person, person: { email: @person.email, first_name: @person.first_name, last_name: @person.last_name, phone: @person.phone }
    assert_redirected_to person_path(assigns(:person))
  end

  test "should get merge" do
    get :merge, id: @person
    assert_response :success
    assert_not_nil(assigns(:person))
  end

  test "should commit merge of people" do
    assert_difference('Person.count', -1) do
      post :commit_merge, id: @person, :other_person_id => people(:persontwo)
    end
  end

  test "should destroy person" do
    assert_difference('Person.count', -1) do
      delete :destroy, id: @person
    end

    assert_redirected_to people_path
  end
end
