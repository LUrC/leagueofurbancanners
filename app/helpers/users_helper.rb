module UsersHelper
  def setup_user(user)
    user.person ||= Person.new
    setup_person(user.person)
    user
  end
end
