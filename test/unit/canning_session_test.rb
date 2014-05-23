require 'test_helper'

class CanningSessionTest < ActiveSupport::TestCase

  setup do
    @canning_session = canning_sessions(:one)
  end

  test "the canning session should return the leader's full name for leader name if there is a leader" do
    assert_equal(@canning_session.leader.full_name, @canning_session.leader_name)
  end

  test "the canning sesion should return 'Unknown' for the leader name if there is no leader" do
    @canning_session.leader = nil;
    assert_equal(@canning_session.leader_name, 'Unknown')
  end

  test "the canning sesion should have the harvest name plus id for its name" do
    assert_equal(@canning_session.session_name, @canning_session.harvest.harvest_name + " #{@canning_session.id}")
  end

end
