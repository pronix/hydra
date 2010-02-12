class TasksController < ApplicationController
  inherit_resources
  defaults :resource_class => Tasks, :collection_name => 'tasks', :instance_name => 'task'
  respond_to :html
  respond_to :js, :only => [:index]

  def index
    index! do |format|
      format.html { render :action => :index }
      format.js { render :action => :index, :layout => false }
    end
  end

  def create
    create! do |success, failure|
      session[:task_status] = "active"
      success.html { redirect_to tasks_path }
      failure.html { render :new }
    end
  end


  protected
  def collection
    session[:task_status]   ||= "active"
    session[:task_category] ||= nil

    session[:task_status] = params[:status] if params[:status]

    if params[:category] && params[:category]["-1"]
      session[:task_category] = nil
    elsif  params[:category]
      session[:task_category] = params[:category]
    end

    @conditions, @arguments = [], { }
    @conditions << case session[:task_status]
                   when /active/
                     " state not in ( :completed_state ) "
                   when /completed/
                     " state in ( :completed_state ) "
                   end
    @arguments.merge!({ :completed_state => %w(completed error )})
    @conditions << " category_id = :category " if session[:task_category]
    @arguments.merge!({ :category => session[:task_category]})  if session[:task_category]
    @conditions = @conditions.join(" AND ")
    @tasks = current_user.tasks.filter(@conditions, @arguments)
  end

  def begin_of_association_chain
    current_user
  end

end
