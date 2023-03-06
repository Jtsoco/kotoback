class CardPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user)
    end
  end

  def show?
    record.book.user == user
    # record: the card passed to the `authorize` method in controller
    # user: the `current_user` signed in with Devise
  end

  def index?
    record.book.user == user
    # record: the card passed to the `authorize` method in controller
    # user: the `current_user` signed in with Devise
  end

  def new?
    record.book.user == user
    # record.user == user
    # record: the card passed to the `authorize` method in controller
    # user: the `current_user` signed in with Devise
  end

  def create?
    record.book.user == user
    # record.user == user
    # record: the card passed to the `authorize` method in controller
    # user: the `current_user` signed in with Devise
  end

  def update?
    record.book.user == user
    # record.user == user
    # record: the card passed to the `authorize` method in controller
    # user: the `current_user` signed in with Devise
  end

  def destroy?
    record.book.user == user
    # record: the card passed to the `authorize` method in controller
    # user: the `current_user` signed in with Devise
  end
end
