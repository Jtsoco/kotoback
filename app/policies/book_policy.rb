class BookPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user)
    end
  end

  def show?
    record.user == user
    # record: the book passed to the `authorize` method in controller
    # user: the `current_user` signed in with Devise
  end

  def study?
    record.user == user
    # record: the book passed to the `authorize` method in controller
    # user: the `current_user` signed in with Devise
  end

  def create?
    true
    # record: the book passed to the `authorize` method in controller
    # user: the `current_user` signed in with Devise
  end

  def update?
    record.user == user
    # record: the book passed to the `authorize` method in controller
    # user: the `current_user` signed in with Devise
  end

  def delete?
    record.user == user
    # record: the book passed to the `authorize` method in controller
    # user: the `current_user` signed in with Devise
  end
end
