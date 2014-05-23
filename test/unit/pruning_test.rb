require 'test_helper'

class PruningTest < ActiveSupport::TestCase

  setup do
    @pruning = prunings(:one)
  end

  test "the pruning should return the leader's full name for leader name if there is a leader" do
    @pruning.leader = people(:personone)
    assert_equal(@pruning.leader.full_name, @pruning.leader_name)
  end

  test "the pruning should return 'Unknown' for the leader name if there is no leader" do
    @pruning.leader = nil;
    assert_equal(@pruning.leader_name, 'Unknown')
  end

end
