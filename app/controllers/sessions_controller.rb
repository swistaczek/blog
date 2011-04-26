class SessionsController < ApplicationController
  def new
  end

  def create
    account = Account.authenticate(params[:accountname], params[:password])
    if account
      session[:account_id] = account.id
      redirect_to root_url
    else
      flash.now.alert = "Niepoprawny login bądź hasło."
      render "new"
    end
  end

  def destroy
    session[:account_id] = nil
    redirect_to root_url
  end

end

