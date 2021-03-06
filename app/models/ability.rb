class Ability
  include CanCan::Ability

  def initialize(user, params)
    Rails.logger.debug(params)
    Rails.logger.debug(user.person)
    can :manage, Person, :id => user.person.id
    if !user
        can :read, :all
    elsif user.role == "admin"
        can :manage, :all
    elsif user.role == "organizer"
        can :manage, [Harvest, CanningSession, Person, StatusCheck, Harvesting, FruitTree, Site, Canning, Fruit]
    else
        can :read, :all
        can :map, :all
        can :create, Site
        can :create, FruitTree
        can :site_chooser, Person, :id => user.person.id
        can :coordinate, Site
        can :edit, Harvest
        can :update, Harvest
        can :create, Harvest
        can :create, Harvesting
        can :destroy, Harvesting if params[:person_id] && params[:person_id].to_i == user.person.id
        can :create, StatusCheck
        can :add_image, StatusCheck
        can :edit, Site, Site do |site| site.lurc_contact == user.person end
        can :update, Site, Site do |site| site.lurc_contact == user.person end
        can :edit, Person
        can :update, Person
        can :create, Person
        can :create, Canning if params[:person_id] && params[:person_id].to_i == user.person.id
        can :destroy, Canning if params[:person_id] && params[:person_id].to_i == user.person.id
        can :create, CanningSession
        can :update, CanningSession
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
