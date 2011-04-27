class AccountsController < ApplicationController

  before_filter :log_in?, :only => [:edit, :update, :index]

  def new
    session[:account_params] ||= {}
    @account = Account.new(session[:account_params])
    @account.current_step = session[:account_step]
  end

  def create
    session[:account_params].deep_merge!(params[:account]) if params[:account]
    @account = Account.new(session[:account_params])
    @account.current_step = session[:account_step]
    if @account.valid?
      if params[:back_button]
        @account.previous_step
      elsif @account.last_step?
        @account.save if @account.all_valid?
      else
        @account.next_step
      end
      session[:account_step] = @account.current_step
    end
    if @account.new_record?
      render "new"
    else
      session[:account_step] = session[:account_params] = nil
      redirect_to root_path
    end
  end

  def edit
    @account = current_user
  end

  def update
    @account = current_user

      if @account.update_attributes(params[:account])
        flash[:notice] = "Powodzenie"
        redirect_to account_path
      else
        flash[:error] = "Napotkano problem #{@account.errors.inspect}"
        redirect_to account_path
      end
    end

end

