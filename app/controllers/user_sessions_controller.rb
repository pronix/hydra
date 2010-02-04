class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new]
  before_filter :require_user, :only => :destroy
  
  def new
    
    if request.post?
      @user_session = UserSession.new(params[:user_session])
      if @user_session.save
        flash[:notice] = I18n.t("login_successful")
        redirect_back_or_default root_path
      else
        render :action => :new
      end
    else
      @user_session = UserSession.new
    end
    
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = I18n.t('Goodbye')
    redirect_back_or_default login_path
  end
end
