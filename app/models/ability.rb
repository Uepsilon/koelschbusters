class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role? :management
      # Access Admin
      can :access, :admin

      # CKEDITOR
      can :access, :ckeditor   # needed to access Ckeditor filebrowser
      can [:read, :create, :destroy], Ckeditor::Picture
      can [:read, :create, :destroy], Ckeditor::AttachmentFile

      # management + admin can manage all users
      can :manage, User

      # Creating News
      can :manage, News

      can :manage, Picture
      can :manage, Gallery
    end

    # all other can edit themselves
    can :edit, User do |u|
        u.id == user.id
    end

    if user.role? :member and not user.role? :management
      # Allow News for Members
      can :read, News, News.published do |news|
        not news.published_at.nil? and news.published_at <= DateTime.now
      end

      can :read, Picture
    end

    unless user.role? :member
      # News for Guests
      can :read, News, News.published.ffa do |news|
        not news.published_at.nil? and news.published_at <= DateTime.now and not news.internal?
      end

      can :read, Picture do |picture|
        not picture.internal?
      end
    end

    can :read, Gallery
    can :read, Ckeditor::Picture
    can :read, Ckeditor::AttachmentFile

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
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
