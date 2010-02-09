class DashboardsController < ApplicationController
  def show
    session[:task_category] ||= nil

    if params[:category] && params[:category]["-1"]
      session[:task_category] = nil
    elsif  params[:category]
      session[:task_category] = params[:category]
    end

    @conditions, @arguments = [], { }
    @conditions << " category_id = :category " if session[:task_category]
    @arguments.merge!({ :category => session[:task_category]})  if session[:task_category]
    @conditions = @conditions.join(" AND ")
    if session[:task_category]
      @tasks = (current_user.admin? ? Task : current_user.tasks).active.filter(@conditions, @arguments)
    else
      @tasks = (current_user.admin? ? Task : current_user.tasks).active
    end


    respond_to do |format|
      format.html { render :show }
      format.js   { render :show, :layout => false}
    end
  end
end
