class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role? :super
      can :manage, :all
    elsif user.has_role? :admin
      can :manage, ActiveAdmin::Page
      can :manage, ActiveAdmin::Comment

      can :manage, User, id: User.with_role(:admin, user).pluck(:id)
      can :manage, User, id: User.with_role(:user, user).pluck(:id)

      can :manage, Role, name: ['admin', 'user']
      can :manage, Block
      can :manage, Card
    else
    end
  end
end
