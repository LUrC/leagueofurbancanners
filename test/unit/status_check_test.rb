require 'test_helper'

class StatusCheckTest < ActiveSupport::TestCase
  setup do
    @status_check = status_checks(:one)
  end

  test "the status check has a name that is based on the fruit tree and date of check" do
    assert_equal(@status_check.check_name, "#{@status_check.fruit_tree.tree_name} status #{@status_check.date.to_s(:human)}")
  end
end
