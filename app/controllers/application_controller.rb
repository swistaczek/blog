class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :log_in?

  private

  def current_user
    @current_user ||= Account.find(session[:account_id]) if session[:account_id]
  end

  def log_in?
    if current_user
    else
      redirect_to root_path
    end
  end

end

