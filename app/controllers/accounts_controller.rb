class AccountsController < ApplicationController

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params[:account])
    if @account.save
      redirect_to root_url, :notice => "Sukces! Zalogowano."
    else
      render "new"
    end
  end

end
