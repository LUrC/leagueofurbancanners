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


end
