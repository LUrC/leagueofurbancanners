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

  before_save :default_harvesters_canners

  def harvest_name
    fruit_tree.tree_name + " " + date.to_s(:human)
  end

  def self.upcoming
    order("date DESC").where("date >= ?", Date.today.to_time)
  end

  def self.past
    order("date DESC").where("date < ?", Date.today.to_time)
  end

  def upcoming?
      date >= Time.now
  end

  def past?
      date < Time.now
  end

  def approved_harvesters
    harvesters[0..harvesters_needed]
  end

  def waitlisted_harvesters
    harvesters[harvesters_needed..-1]
  end

  private
  def default_harvesters_canners
    self.harvesters_needed = 2 unless harvesters_needed
    self.canners_needed = 1 unless canners_needed
  end

end
