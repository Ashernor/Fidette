# encoding: utf-8
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Félicitations vous êtes bien inscris !"
    else
      render :new
    end
  end

  def statistics
    if current_user
      @stats                = DebtStats.new({user_id: current_user.id})
      @start_date           = @stats.start_date
      @end_date             = @stats.end_date
    end
  end

end
