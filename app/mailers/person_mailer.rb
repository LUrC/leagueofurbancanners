class PersonMailer < ActionMailer::Base
  default from: "admin@leagueofurbancanners.heroku.com"

  SUBJECT_PREFIX = "[LURC] "

  def harvesting_reminder(harvest, harvesting, message, to_person, from_person)
    @harvest = harvest
    @harvesting = harvesting
    @message = message
    @to_person = to_person
    @from_person = from_person
    mail(:to => to_person.email, :from => from_person.email, :subject => SUBJECT_PREFIX + "Harvest Reminder")
  end

  def harvest_reminder(harvest, message, from_person, include_waitlist=false)
    @harvest = harvest
    @message = message
    @harvesters = @harvest.approved_harvesters
    @harvesters = @harvest.harvesters if include_waitlist
    @from_person = from_person
    mail(:to => @harvesters.map(&:email), :from => from_person.email, :subject => SUBJECT_PREFIX + "Harvest Reminder")
  end

end
