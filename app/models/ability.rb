# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    if user.role? :super_admin
      can :manage, :all
    end

    if user.role? :super_admin
      can :manage, :all
    end

    if user.role? :agent
      can :products, :index

      can :orders, :index
      can :orders, :show
      can :orders, :server_admins
      can :orders, :set_server_admin
      can :orders, :get_desc
      can :orders, :set_desc
      can :orders, :show

      can :users, :index
      can :users, :qrcode
      can :users, :set_admin
      can :users, :admin

      can :admin_commission_logs, :index

      can :server_users, :index
      can :server_users, :cash_form
      can :server_users, :cash

      can :profiles, :edit
      can :profiles, :update

      can :in_payments, :index

      user.role&.resources&.each do |resource|
        can resource.target.to_sym, resource.action.to_sym
      end
    end
  end
end
