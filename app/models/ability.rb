class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, Account do |account|
      account.id == user.account_id
    end

    can :manage, Site do |site|
      site.account_id == user.account_id
    end

    can :read, Page do |page|
      page.account == user.account
    end

    can :read, Visit do |visit|
      visit.account == user.account
    end
  end
end
