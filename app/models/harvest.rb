class Harvest < ActiveRecord::Base
  attr_accessible :amount_harvested, :canners_needed, :date, :description, :fruit_tree_id, :harvesters_needed, :leader_id, :notes
  
  belongs_to :fruit_tree
  has_one :site, :through => :fruit_tree
  belongs_to :leader, :class_name => "Person"
  has_many :harvestings, :dependent => :destroy
  has_many :harvesters, :through => :harvestings, :class_name => "Person"
  has_many :canning_sessions, :dependent => :destroy
  has_many :cannings, :through => :canning_sessions
  has_many :canners, :through => :cannings, :class_name => "Person"
  
  def harvest_name
    fruit_tree.tree_name + " " + date.to_s(:human)
  end
  
  def self.upcoming
    order("date DESC").where("date >= ?", Date.today.to_time)
  end
  
  def self.past
    where("date < ?", Date.today.to_time)
  end
  
  def upcoming? 
      date >= Time.now
  end
  
  def past?
      date < Time.now
  end
  
end
