class Harvesting < ActiveRecord::Base
  attr_accessible :harvest_id, :hours, :harvester_id

  belongs_to :harvest
  belongs_to :harvester, :class_name => "Person"

  def status
    if harvest.upcoming?
        index = harvest.harvestings.index(self)
        if (index < harvest.harvesters_needed)
            "Approved"
        else
            "Waitlist: #{harvest.harvesters_needed - index + 1}"
        end
    else
        "Complete"
    end
  end

end
