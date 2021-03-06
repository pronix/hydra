class TasksController < ApplicationController
  inherit_resources
  defaults :resource_class => Tasks, :collection_name => 'tasks', :instance_name => 'task'
  respond_to :html
  respond_to :js, :only => [:index]

  def index
    index! do |format|
      format.html { render :action => :index }
      format.js { render :partial => "tasks", :layout => false, :object => @tasks }
    end
  end

  def show; @task = (current_user.admin? ? Task : current_user.tasks).find params[:id]  end

  def create
    if params[:task][:category_id]
    create! do |success, failure|
      session[:task_status] = "active"
      success.html { redirect_to tasks_path }
      failure.html { render :new }
    end
    else
      flash[:notice] = 'выберите категорию'
      redirect_to :back
    end
  end

  # Завершение задачи
  def complete
    @task = current_user.tasks.find params[:id]
    # Task.send_later(:comlete!, @task)
    @task.complete! if @task.finished?
    flash[:notice] = I18n.t('start_completed')
    redirect_to task_path(@task)
  end

  # Повторная генерация скрин листов
  def regenerate
    @task = current_user.tasks.find params[:id]
    @task && @task.finished? && @task.regenerate!
    flash[:notice] = I18n.t('restart_generate_screen_list')
    redirect_to task_path(@task)
  end

  # Повторная загрузка изображений
  def reuploading
    @task = current_user.tasks.find params[:id]
    @task && @task.finished? && @task.reuploading!
    flash[:notice] = I18n.t('restart_uploding_screen_list')
    redirect_to task_path(@task)
  end
  # Повторная загрузка обложек
  def reuploading_covers
    @task = current_user.tasks.find params[:id]
    @task && @task.finished? && @task.reuploading_covers!
    flash[:notice] = I18n.t('restart_uploading_covers')
    redirect_to task_path(@task)
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
                     " workflow_state not in ( :completed_state ) "
                   when /completed/
                     " workflow_state in ( :completed_state ) "
                   end
    @arguments.merge!({ :completed_state => %w(completed)})
    @conditions << " category_id = :category " if session[:task_category]
    @arguments.merge!({ :category => session[:task_category]})  if session[:task_category]
    @conditions = @conditions.join(" AND ")
    @tasks = (current_user.admin? ? Task : current_user.tasks).filter(@conditions, @arguments).paginate :per_page => current_user.user_per_page, :page => params[:page]
  end

  def begin_of_association_chain
    current_user
  end

end
