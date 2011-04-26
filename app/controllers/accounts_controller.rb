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
      @account = Account.find(session[:account_id])
  end

  def update
    @account = Account.find(session[:account_id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to(@account, :notice => 'Category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

end

