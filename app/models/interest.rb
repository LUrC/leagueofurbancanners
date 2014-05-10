class Interest < ActiveRecord::Base
  attr_accessible :name

  has_many :person_interests
  has_many :people, :through => :person_interests

end
