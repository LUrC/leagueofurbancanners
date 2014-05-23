require 'test_helper'

class HarvestTest < ActiveSupport::TestCase

  setup do
    @harvest = harvests(:one)
    @harvest2 = harvests(:two)
    @harvest3 = harvests(:three)
  end

  test "the harvest name is the fruit tree and date of harvest" do
    assert_equal(@harvest.harvest_name, @harvest.fruit_tree.tree_name + " " + @harvest.date.to_s(:human))
  end

  test "the class can retrive a list of the upcoming harvests" do
    harvests = Harvest.upcoming
    assert !harvests.include?(@harvest)
    assert !harvests.include?(@harvest2)
    assert harvests.include?(@harvest3)
  end

  test "the class can retrive a list of the past harvests" do
    harvests = Harvest.past
    assert harvests.include?(@harvest)
    assert harvests.include?(@harvest2)
    assert !harvests.include?(@harvest3)
  end

  test "a harvest can tell if it is upcoming" do
    assert_equal(@harvest.upcoming?, false)
    assert_equal(@harvest3.upcoming?, true)
  end

  test "a harvest can tell if it past" do
    assert_equal(@harvest.past?, true)
    assert_equal(@harvest.upcoming?, false)
  end

  test "a harvest can produce the approved harvesters, which will not exceed the number needed" do
    assert(@harvest.harvesters.length > @harvest.harvesters_needed)
    assert_equal(@harvest.approved_harvesters.length, @harvest.harvesters_needed)
  end

  test "a harvest can producer the waitlisted harvesters, those above the number needed" do
    assert_equal(@harvest.waitlisted_harvesters.length, @harvest.harvesters.length - @harvest.harvesters_needed)
  end

  test "the harvest should return the leader's full name for leader name if there is a leader" do
    assert_equal(@harvest.leader.full_name, @harvest.leader_name)
  end

  test "the harvest should return 'Unknown' for the leader name if there is no leader" do
    @harvest.leader = nil;
    assert_equal(@harvest.leader_name, 'Unknown')
  end

  test "the harvest should set default harvesters and canners needed when saved if it has none" do
    harvest = Harvest.new
    harvest.save
    assert_equal(harvest.canners_needed, 1)
    assert_equal(harvest.harvesters_needed, 2)
  end
end
