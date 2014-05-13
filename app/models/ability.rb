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
        can :site_chooser, Person, :id => user.person.id
        can :coordinate, Site if params[:person_id].to_i == user.person.id
        can :create, Harvest if params[:harvest] && FruitTree.find(params[:harvest][:fruit_tree_id]).site.lurc_contact.id = user.person.id
        can :update, Harvest if params[:harvest] && FruitTree.find(params[:harvest][:fruit_tree_id]).site.lurc_contact.id = user.person.id
        can :create, Harvesting if params[:person_id] && params[:person_id].to_i == user.person.id
        can :destroy, Harvesting if params[:person_id] && params[:person_id].to_i == user.person.id
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
