class SessionsController < ApplicationController
  def new
  end

  def create
    account = Account.authenticate(params[:accountname], params[:password])
    if account
      session[:account_id] = account.id
      account.increment!(:login_count)
      redirect_to root_url
    else
      flash.now.alert = "Niepoprawne dane logowania."
      render "new"
    end
  end

  def destroy
    session[:account_id] = nil
    redirect_to root_url
  end

end

