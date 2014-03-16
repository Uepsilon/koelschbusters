class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new(role: "guest", member_active: true)

    # Abilitys for all
    can :read,    Category
    can :create,  Contact

    can :read,    Ckeditor::Picture
    can :read,    Ckeditor::AttachmentFile

    send(@user.role)
  end

  def admin
    management
  end

  def management
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
    can :manage, Category

    can :manage, NewsComment
  end

  def member
    can :read, News, News.published do |news|
      news.published?
    end

    can :read, Picture
    can :read, Gallery do |gallery|
      gallery.pictures.any?
    end

    # Users can edit themselves
    can :edit, User do |u|
        u.id == @user.id
    end

    # can read and create comments for news, can also edit / delete his own comments
    can :read, NewsComment, ["activated_at < ?", DateTime.now] do |comment|
      comment.active?
    end
    can :manage, NewsComment, user_id: @user.id
  end

  def guest
    can :read, News, News.published.ffa do |news|
      news.published? and news.public?
    end

    can :read, Picture do |picture|
      picture.public?
    end

    # can :read, Gallery
    can :read, Gallery do |gallery|
      gallery.public_pictures.any?
    end

    # can read and create Comments for News
    can :read, NewsComment, ["activated_at < ?", DateTime.now] do |comment|
      comment.active?
    end
    can :create, NewsComment
  end
end
