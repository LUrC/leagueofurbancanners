module PeopleHelper

  def setup_person(person)
    (Interest.all - person.interests).each do |interest|
      person.person_interests.build(:interest_id => interest.id)
    end
    person.person_interests.sort_by! {|x| x.interest.name }
    person
  end
end
