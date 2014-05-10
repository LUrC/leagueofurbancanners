class Canning < ActiveRecord::Base
  attr_accessible :canner_id, :canning_session_id, :hours

  belongs_to :canner, :class_name => "Person"
  belongs_to :canning_session

  def canner_name
    canner ? canner.full_name : "Unknown"
  end
end
