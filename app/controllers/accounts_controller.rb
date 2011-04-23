class AccountsController < ApplicationController

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params[:account])
    if @account.save
      redirect_to root_url
    else
      render "new"
    end
  end
  
  def edit
    @account = current_user
  end

  def update
    @account = current_user
    if @account.update_attributes(params[:account])
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end

end
