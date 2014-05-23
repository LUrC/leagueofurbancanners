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
    trees = FruitTree.by_street
    (0..trees.length-2).each do |index|
      assert trees[index].site.street_name < trees[index+1].site.street_name
    end
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

  test "has latitude and longitude methods that return the site's lat and lon" do
    assert_equal @fruit_tree.latitude, @fruit_tree.site.lat
    assert_equal @fruit_tree.longitude, @fruit_tree.site.lon
  end

  test "returns a blank gmaps4rails address if the site address data is not there" do
    @fruit_tree.site = nil
    assert @fruit_tree.gmaps4rails_address, ""
  end

  test "makes a list item of the tree name for the gmaps4rails sidebar" do
    assert_equal @fruit_tree.gmaps4rails_sidebar, "<li>#{@fruit_tree.tree_name}</li>"
  end

  test "uses a fruit picture for the map when there is one" do
    Rails.application.assets.stub 'find_asset', true do
      assert_equal @fruit_tree.gmaps4rails_marker_picture["picture"], '/assets/apple.png'
    end
  end

  test "uses a tree picture for the map when there isn't one" do
    Rails.application.assets.stub 'find_asset', false do
      assert_equal @fruit_tree.gmaps4rails_marker_picture["picture"], '/assets/tree.png'
    end
  end

end
