# encoding: utf-8
class StatisticsController < ApplicationController

  def appstatistics
    @debtsordered = Debt.unpaid.order("value").group('debts.id, debts.debtor_id')
    @creditordered = Debt.unpaid.order("value").group('debts.id, debts.creditor_id')
    @biggesunpaiddebts = Debt.unpaid.order("value DESC").first(5)
    @biggestdebts = Debt.unpaid.order("value DESC").first(5)
    @bigdebtorordered = []
    @bigcreditordered = []
    users = User.find(:all)
    users.each do |u|
      h = {value: u.debts.unpaid.sum(:value), name: u.first_name}
      @bigdebtorordered << h
    end
    users.each do |u|
      h = {value: u.credits.unpaid.sum(:value), name: u.first_name}
      @bigcreditordered << h
    end
  end
end
