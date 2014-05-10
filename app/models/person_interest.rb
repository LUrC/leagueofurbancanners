class PersonInterest < ActiveRecord::Base
  attr_accessible :person_id, :interest_id

  belongs_to :person
  belongs_to :interest

end
