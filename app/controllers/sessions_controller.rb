# encoding: utf-8
class SessionsController < ApplicationController

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      redirect_back_or_to root_url, :notice => "Connecté !"
    else
      render :action => "new"
      flash.now.alert = "email ou mot de passe invalide."
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Déconnecté !"
  end
end
