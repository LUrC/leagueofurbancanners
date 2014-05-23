require 'test_helper'

class CanningTest < ActiveSupport::TestCase

  setup do
    @canning = cannings(:one)
  end

  test "the canning should return the canners's full name for canner name if there is a canner" do
    assert_equal(@canning.canner.full_name, @canning.canner_name)
  end

  test "the canning should return 'Unknown' for the canner name if there is no canner" do
    @canning.canner = nil;
    assert_equal(@canning.canner_name, 'Unknown')
  end
end
