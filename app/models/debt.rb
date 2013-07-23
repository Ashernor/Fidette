class Debt < ActiveRecord::Base
  attr_accessible :body, :date, :title, :value, :is_paid, :creditor_id, :debtor_id

  belongs_to :creditor, :class_name => "User", :foreign_key => :creditor_id
  belongs_to :debtor, :class_name => "User", :foreign_key => :debtor_id

  scope :paid, where("is_paid = true")
  scope :unpaid, where("is_paid = false")

end
