require 'test_helper'

class SiteTest < ActiveSupport::TestCase

  setup do
    @site1 = sites(:one)
    @site2 = sites(:two)
    @site3 = sites(:three)
  end

  test "the class should be able to get all site ordered by street" do
    sites = Site.by_street
    (0..sites.length-2).each do |index|
      assert sites[index].street_name < sites[index+1].street_name
    end
  end

  test "can filter a list of sites to just the coordinated ones" do
    @site1.lurc_contact = nil
    @site2.lurc_contact = people(:personone)
    filtered = Site.filter_sites_by([@site1, @site2], 'Coordinated')
    assert filtered.include?(@site2), "coordinated site included"
    assert !filtered.include?(@site1), "uncoordinated site not included"
  end

  test "can filter a list of sites to just the not coordinated ones" do
    @site1.lurc_contact = nil
    @site2.lurc_contact = people(:personone)
    filtered = Site.filter_sites_by([@site1, @site2], 'Not Coordinated')
    assert !filtered.include?(@site2), "coordinated site not included"
    assert filtered.include?(@site1), "uncoordinated site included"
  end

  test "returns unfiltered list when an unknown filter given" do
    arr = [@site1, @site2]
    filtered = Site.filter_sites_by(arr, 'Foo')
    assert_equal arr, filtered
  end

  test "can filter a list of sites by zipcode" do
    @site1.zipcode = "02138"
    @site2.zipcode = "02139"
    filtered = Site.filter_sites_by_zipcodes([@site1, @site2], ["02138"])
    assert filtered.include?(@site1), "site w/ zipcode included"
    assert !filtered.include?(@site2), "site w/ other zipcode not included"
  end

  test "gives the street address with number when user is authorized" do
    User.stub :session_current_user, people(:personone).user do
      assert_equal(@site1.site_name, "#{@site1.street_name} (##{@site1.street_number})")
    end
  end

  # test "hides the street number when user is not authorized to see it" do
  #   User.stub :session_current_user, users(:two) do
  #     assert_equal(@site1.site_name, "#{@site1.street_name} (#hidden)")
  #   end
  # end

  test "gives the owner name if owner is present" do
    @site1.owner = people(:personone)
    assert_equal(@site1.owner_name, @site1.owner.full_name)
  end

  test "gives unknown for the owner name if there is no owner" do
    @site1.owner = nil
    assert_equal(@site1.owner_name, "Unknown")
  end

  test "gives the secondary owner name if secondary owner is present" do
    @site1.secondary_owner = people(:personone)
    assert_equal(@site1.secondary_owner_name, @site1.secondary_owner.full_name)
  end

  test "gives unknown for the secondary owner name if there is no secondary owner" do
    @site1.secondary_owner = nil
    assert_equal(@site1.secondary_owner_name, "None")
  end

  test "gives the site coordinator name if site coordinator is present" do
    @site1.lurc_contact = people(:personone)
    assert_equal(@site1.lurc_contact_name, @site1.lurc_contact.full_name)
  end

  test "gives unknown for the site coordinator name if there is no site coordinator" do
    @site1.lurc_contact = nil
    assert_equal(@site1.lurc_contact_name, "None")
  end

  test "can get a list of all of the unique zipcodes" do
    zips = Site.zipcodes
    Site.all.map(&:zipcode).each do |z|
      assert zips.include?(z), "#{z} in zipcodes"
    end
    assert_equal zips.uniq.length, zips.length
  end

  test "can give the address as a string based on the address data" do
    @site1.street_number = 1
    @site1.street_name = "Street"
    @site1.city = "City"
    @site1.zipcode = "02138"
    assert_equal(@site1.address, "1 Street, City, MA 02138")
  end

  test "gives a gmaps title of the street address and list of fruits" do
    @site1.street_number = 1
    @site1.street_name = "Street"
    assert_equal(@site1.gmaps4rails_title, "1 Street fruits: Apple")
  end

  test "makes a list item for gmaps4rails sidebar using the site name" do
    assert_equal(@site1.gmaps4rails_sidebar, "<li>#{@site1.site_name}</li>")
  end

  test "gives owner contact status of owner unknown if there is no owner" do
    @site1.owner = nil
    assert_equal @site1.owner_contact_status, "owner unknown"
  end

  test "give no contact info for owner contact status if there is no name, email, or phone" do
    @site1.owner.first_name = nil
    @site1.owner.last_name = ""
    @site1.owner.email = nil
    @site1.owner.phone = nil
    assert_equal @site1.owner_contact_status, "no contact info"
  end

  test "gives phone only for owner contact status if there is no email but there is a phone" do
    @site1.owner.email = nil
    @site1.owner.phone = 'sigil'
    assert_equal @site1.owner_contact_status, "phone number"
  end

  test "gives email only for owner contact status if there is no phone but there is an email" do
    @site1.owner.email = 'sigil'
    @site1.owner.phone = nil
    assert_equal @site1.owner_contact_status, "email address"
  end

  test "gives name only for owner contact status if there is no email or phone there is a name" do
    @site1.owner.first_name = "sigil"
    @site1.owner.last_name = "sigil"
    @site1.owner.email = nil
    @site1.owner.phone = nil
    assert_equal @site1.owner_contact_status, "name only"
  end

  test "gives phone number and email for owner contact status if both are present" do
    @site1.owner.email = "sigil"
    @site1.owner.phone = "sigil"
    assert_equal @site1.owner_contact_status, "email and phone"
  end

  test "class can return a list of statuses, site filters, and ratings options" do
    Site.STATUSES
    Site.RATINGS
    Site.SITE_FILTERS
  end

  test "can find a list of closest sites based on lat and lon not including coordinated sites" do
    Site.closest_sites(0, 0, 5)
  end

  test "can find a list of closest sites based on lat and lon including coordinated" do
    Site.closest_sites(0, 0, 5, true)
  end
end
