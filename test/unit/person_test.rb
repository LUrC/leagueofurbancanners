require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  setup do
    @person = people(:personone)
  end

  test "cannot save a person without a last name" do
    @person.last_name = nil
    assert !@person.save
  end

  test "the full name should be the first name and then the last name" do
    @person.first_name = "Foo"
    @person.last_name = "Bar"
    assert_equal(@person.full_name, "Foo Bar")
  end

  test "can merge in another person by copying over their data" do
    newp = Person.new
    newp.gmaps = true
    newp.last_name = "Foo"
    newp.owned_sites << sites(:two)
    newp.contact_sites << sites(:three)
    newp.save
    @person.merge_in(newp)
    assert !Person.exists?(newp)
    assert(@person.owned_sites.include?(sites(:two)))
    assert(@person.contact_sites.include?(sites(:three)))
  end

  test "merging in another person should copy over data if there is none on the target person" do
    newp = Person.new
    newp.email = "foo@foo.com"
    newp.first_name = "foo"
    newp.street_number = 1
    newp.street_name = "street"
    newp.city = "city"
    newp.zipcode = "00000"
    newp.phone = "phone"
    newp.gmaps = true
    newp.save
    @person.email = nil
    @person.first_name = nil
    @person.street_number = nil
    @person.street_name = nil
    @person.city = nil
    @person.zipcode = nil
    @person.phone = nil
    @person.gmaps = true
    @person.merge_in(newp)
    assert_equal(@person.email, "foo@foo.com")
    assert_equal(@person.first_name, "foo")
    assert_equal(@person.street_number, 1)
    assert_equal(@person.street_name, "street")
    assert_equal(@person.city, "city")
    assert_equal(@person.zipcode, "00000")
    assert_equal(@person.phone, "phone")
  end

  test "merging in another person should not overwrite data if already set" do
    newp = Person.new
    newp.email = "foo@foo.com"
    newp.first_name = "foo"
    newp.street_number = 1
    newp.street_name = "street"
    newp.city = "city"
    newp.zipcode = "00000"
    newp.phone = "phone"
    newp.gmaps = true
    newp.save
    @person.email = "oldemail"
    @person.first_name = "oldfirstname"
    @person.street_number = 0
    @person.street_name = "oldstreet"
    @person.city = "oldcity"
    @person.zipcode = "02138"
    @person.phone = "oldphone"
    @person.gmaps = true
    @person.merge_in(newp)
    assert_equal(@person.email, "oldemail")
    assert_equal(@person.first_name, "oldfirstname")
    assert_equal(@person.street_number, 0)
    assert_equal(@person.street_name, "oldstreet")
    assert_equal(@person.city, "oldcity")
    assert_equal(@person.zipcode, "02138")
    assert_equal(@person.phone, "oldphone")
  end

  test "all_sites should collect all the sites with which a person is associated" do
    @person.owned_sites = [sites(:one)]
    @person.secondary_owned_sites = [sites(:two)]
    @person.contact_sites = [sites(:three)]
    assert @person.all_sites.include?(sites(:one))
    assert @person.all_sites.include?(sites(:two))
    assert @person.all_sites.include?(sites(:three))
  end

  test "all sites should not return duplicates" do
    @person.owned_sites = [sites(:one)]
    @person.secondary_owned_sites = [sites(:one)]
    @person.contact_sites = [sites(:one)]
    assert_equal @person.all_sites.length, 1
  end

  test "generates string of site roles based on site roles" do
    @person.owned_sites.clear
    @person.secondary_owned_sites.clear
    @person.contact_sites.clear
    assert_equal(@person.site_role(sites(:one)), "")
    @person.owned_sites << sites(:one)
    assert_equal(@person.site_role(sites(:one)), "owner")
    assert_equal(@person.site_role(sites(:two)), "")
    @person.contact_sites << sites(:one)
    @person.contact_sites << sites(:two)
    assert_equal(@person.site_role(sites(:one)), "owner, site coordinator")
    assert_equal(@person.site_role(sites(:two)), "site coordinator")
    @person.secondary_owned_sites << sites(:one)
    @person.secondary_owned_sites << sites(:two)
    assert_equal(@person.site_role(sites(:one)), "owner, secondary owner, site coordinator")
    assert_equal(@person.site_role(sites(:two)), "secondary owner, site coordinator")
  end

  test "copies email from user when saved if not set on person" do
    @person.email = nil;
    @person.user.email = "foo"
    @person.save
    assert_equal(@person.email, "foo")
  end

  test "can save a person with no address" do
    person = Person.new
    person.gmaps = true
    person.last_name = "foo"
    person.save
    assert (Person.exists?(person))
  end

  test "can get a list of past harvestings" do
    past = harvestings(:one)
    future = harvestings(:three)
    @person.harvestings.clear
    @person.harvestings << past
    @person.harvestings << future
    assert @person.past_harvestings.include?(past)
    assert !@person.past_harvestings.include?(future)
  end

  test "can get a list of future harvestings" do
    past = harvestings(:one)
    future = harvestings(:three)
    @person.harvestings.clear
    @person.harvestings << past
    @person.harvestings << future
    assert !@person.upcoming_harvestings.include?(past)
    assert @person.upcoming_harvestings.include?(future)
  end


  test "can get a list of past harvests" do
    past = harvestings(:one)
    future = harvestings(:three)
    @person.harvestings.clear
    @person.harvestings << past
    @person.harvestings << future
    assert @person.past_harvests.include?(past.harvest)
    assert !@person.past_harvests.include?(future.harvest)
  end

  test "can get a list of future harvests" do
    past = harvestings(:one)
    future = harvestings(:three)
    @person.harvestings.clear
    @person.harvestings << past
    @person.harvestings << future
    assert !@person.upcoming_harvests.include?(past.harvest)
    assert @person.upcoming_harvests.include?(future.harvest)
  end

  test "does not fail to produce a full name even if first or last name is nil" do
    @person.first_name = nil
    @person.last_name = "foo"
    assert_equal @person.full_name, " foo"
    @person.first_name = "foo"
    @person.last_name = nil
    assert_equal @person.full_name, "foo "
    @person.first_name = nil
    @person.last_name = nil
    assert_equal @person.full_name, " "
  end

  test "uses a person picture for the gmaps4rails marker" do
    assert_equal @person.gmaps4rails_marker_picture['picture'], '/assets/person.png'
  end

  test "uses a list item of the person's full name for the gmaps sidebar" do
    assert_equal @person.gmaps4rails_sidebar, "<li>#{@person.full_name}</li>"
  end

  test "uses a person's full name as the gmaps4rails title" do
    assert_equal @person.gmaps4rails_title, @person.full_name
  end

  test "uses the address data to make a gmaps4rails address" do
    @person.street_number = 1
    @person.street_name = "Street"
    @person.city = "City"
    @person.zipcode = "02138"
    assert_equal @person.gmaps4rails_address, "1 Street, City, MA 02138"
  end
end
