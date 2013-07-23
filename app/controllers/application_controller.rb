# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def not_authenticated
    redirect_to login_url, :alert => "Connectez-vous d'abord pour accéder à cette page."
  end

end
