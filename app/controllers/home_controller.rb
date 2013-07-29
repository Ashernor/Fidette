class HomeController < ApplicationController
  def index
    if current_user
      @stats                = DebtStats.new({user_id: current_user.id})
      @start_date           = @stats.start_date
      @end_date             = @stats.end_date
    end
  end
end