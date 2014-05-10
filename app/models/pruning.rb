class Pruning < ActiveRecord::Base
  attr_accessible :date, :fruit_tree_id, :leader_id

  belongs_to :fruit_tree
  belongs_to :leader, :class_name => "Person"

  def leader_name
    leader ? leader.full_name : "Unknown"
  end

end
