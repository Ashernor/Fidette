class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name

  validates_confirmation_of :password
  validates_presence_of :email, :first_name, :last_name
  validates_uniqueness_of :email

  has_many :debts, :class_name => "Debt", :foreign_key => :debtor_id
  has_many :credits, :class_name => "Debt", :foreign_key => :creditor_id

  has_many :ideas

  def amount_owed
    current_owed = Debt.unpaid.where("debtor_id = ?", self.id).map {|s| s['value']}.reduce(0, :+)
    return current_owed
  end

  def total_amount_owed
    total_current_owed = Debt.unpaid.where("debtor_id = ?", self.id).map {|s| s['value']}.reduce(0, :+)
    return total_current_owed
  end

end
