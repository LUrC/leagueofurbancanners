require 'test_helper'

class HarvestingTest < ActiveSupport::TestCase
  setup do
    @harvesting = harvestings(:one)
    @harvesting3 = harvestings(:three)
    @harvesting7 = harvestings(:eight)
  end

  test "the harvesting should return the harvester's full name for harvester name if there is a harvester" do
    assert_equal(@harvesting.harvester.full_name, @harvesting.harvester_name)
  end

  test "the harvesting should return 'Unknown' for the harvester name if there is no harvester" do
    @harvesting.harvester = nil;
    assert_equal(@harvesting.harvester_name, 'Unknown')
  end

  test "the harvesting should return an approved status if the harvest is upcoming and harvester is approved" do
    assert_equal(@harvesting3.status, 'Approved')
  end

  test "the harvesting should return a waitlist status if the harvest is upcoming and the harvester is waitlisted" do
    assert_equal(@harvesting7.status, 'Waitlist: 0')
  end

  test "the harvesting should return a complete status if it is in the past" do
    assert_equal(@harvesting.status, 'Complete')
  end

end
