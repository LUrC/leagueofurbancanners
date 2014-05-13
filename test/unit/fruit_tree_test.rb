require 'test_helper'

class FruitTreeTest < ActiveSupport::TestCase

  setup do
    @fruit_tree = fruit_trees(:one)
    @other_fruit_tree = fruit_trees(:two)
  end

  test "the tree should provide a distinctive tree_name" do
    assert_not_nil(@fruit_tree.tree_name)
    assert_not_equal(@fruit_tree.tree_name, @other_fruit_tree.tree_name)
  end

  test "the tree should provide an address for gmaps4rails based on its site" do
    assert_equal(@fruit_tree.gmaps4rails_address, @fruit_tree.site.gmaps4rails_address)
  end

  test "the gmaps4rails title should be the tree name" do
    assert_equal(@fruit_tree.gmaps4rails_title, @fruit_tree.tree_name)
  end

  test "the class should be able to return all members sorted by street name" do
    flunk
  end

  test "the fruit tree should return its gmaps4rails longitude when asked for longitude" do
    flunk
  end

  test "the fruit tree should return its gmaps4rails latitude when asked for latitude" do
    flunk
  end

  test "the tree should return the fruit season start month if it does not have one set" do
    @fruit_tree.season_start_month = nil
    assert_equal(@fruit_tree.start_month, @fruit_tree.fruit.season_start_month)
  end

  test "the tree should return the fruit seasons end month if it does not have one set" do
    @fruit_tree.season_end_month = nil
    assert_equal(@fruit_tree.end_month, @fruit_tree.fruit.season_end_month)
  end

  test "the tree should return the fruit season start day if it does not have one set" do
    @fruit_tree.season_start_day = nil
    assert_equal(@fruit_tree.start_day, @fruit_tree.fruit.season_start_day)
  end

  test "the tree should return the fruit season end day if it does not have one set" do
    @fruit_tree.season_end_month = nil
    assert_equal(@fruit_tree.end_month, @fruit_tree.fruit.season_end_month)
  end

  test "the tree should return the fruit season start month if it does have one set" do
    @fruit_tree.season_start_month = "October"
    assert_equal(@fruit_tree.start_month, @fruit_tree.season_start_month)
  end

  test "the tree should return the fruit seasons end month if it does have one set" do
    @fruit_tree.season_end_month = "October"
    assert_equal(@fruit_tree.end_month, @fruit_tree.season_end_month)
  end

  test "the tree should return the fruit season start day if it does have one set" do
    @fruit_tree.season_start_day = 13
    assert_equal(@fruit_tree.start_day, @fruit_tree.season_start_day)
  end

  test "the tree should return the fruit season end day if it does have one set" do
    @fruit_tree.season_end_day = 13
    assert_equal(@fruit_tree.end_day, @fruit_tree.season_end_day)
  end

  test "the season string should give a nicely formatted season" do
    @fruit_tree.season_start_month = "October"
    @fruit_tree.season_start_day = 1
    @fruit_tree.season_end_month = "November"
    @fruit_tree.season_end_day = 13
    assert_equal(@fruit_tree.season_string, "October 1-November 13")
  end

end
