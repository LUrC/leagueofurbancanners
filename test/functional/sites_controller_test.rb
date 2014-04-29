require 'test_helper'

class SitesControllerTest < ActionController::TestCase
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

    @site = sites(:one)
    @uncoordinated_site = sites(:three)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "index action should set filters in session if set parameter present" do
    get :index, :set => true, :site_filters => ['Coordinated'], :fruit_ids => ['1','2'], :zipcode_filters => ['02138']
    assert_equal ['Coordinated'], session[:site_filters]
    assert_equal [1,2], session[:fruit_ids]
    assert_equal ['02138'], session[:zipcode_filters]
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site" do
    assert_difference('Site.count') do
      post :create, site: { city: @site.city, lurc_contact_id: @site.lurc_contact_id, note: @site.note, owner_id: @site.owner_id, secondary_owner_id: @site.secondary_owner_id, status: @site.status, street_name: @site.street_name, street_number: @site.street_number, zipcode: @site.zipcode, gmaps: true }
    end

    assert_redirected_to site_path(assigns(:site))
  end

  test "should show site" do
    get :show, id: @site
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @site
    assert_response :success
  end

  test "should assign a coordinator to an unassigned site" do
    person = people(:personone)
    get :coordinate, id: @uncoordinated_site, :person_id => person
    assert_equal(person.id, assigns(:site).lurc_contact_id)
    assert_redirected_to(assigns(:person))
  end

  test "should not assign a coordinator to a site that is already coordinated" do
    person = people(:persontwo)
    get :coordinate, id: @site, :person_id => person
    assert_not_equal(person.id, assigns(:site).lurc_contact_id)
    assert_redirected_to(site_chooser_person_path(assigns(:person)))
  end

  test "should not assign a coordinator when a person parameter not provided" do
    get :coordinate, id: @uncoordinated_site
    assert_nil(assigns(:site).lurc_contact_id)
    assert_redirected_to(assigns(:site))
  end

  test "should show a map of all sites" do
    get :map
    assert(assigns(:sites))
    assert(assigns(:map_json))
    assert_response :success
  end

  test "map action should set filters in session if set parameter present" do
    get :map, :set => true, :site_filters => ['Coordinated'], :fruit_ids => ['1','2'], :zipcode_filters => ['02138']
    assert_equal ['Coordinated'], session[:site_filters]
    assert_equal [1,2], session[:fruit_ids]
    assert_equal ['02138'], session[:zipcode_filters]
  end

  test "should clear all filters in the session" do
    @request.env['HTTP_REFERER'] = 'http://test.com/sites'
    get :clear_filters
    assert_nil session[:site_filters]
    assert_nil session[:fruit_ids]
    assert_nil session[:zipcode_filters]
    assert_nil session[:sort]
    assert_nil session[:direction]
    assert_redirected_to(sites_path)
  end

  test "should update site" do
    put :update, id: @site, site: { city: @site.city, lurc_contact_id: @site.lurc_contact_id, note: @site.note, owner_id: @site.owner_id, secondary_owner_id: @site.secondary_owner_id, status: @site.status, street_name: @site.street_name, street_number: @site.street_number, zipcode: @site.zipcode }
    assert_redirected_to site_path(assigns(:site))
  end

  test "should destroy site" do
    assert_difference('Site.count', -1) do
      delete :destroy, id: @site
    end

    assert_redirected_to sites_path
  end
end
