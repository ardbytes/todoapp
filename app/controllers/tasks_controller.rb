class TasksController < ApplicationController

  def index
    @tasks = current_user.tasks
  end

  def new
    @tags = Tag.all.sort_by {|t| t.title}.map {|t| [t.title, t.id]}
    @task = Task.new
  end

  def edit
    @task = current_user.tasks.find(params[:id])
    @all_tags = Tag.all.sort_by {|t| t.title}.map {|t| [t.title, t.id]}
    render :layout => false
  end

  def today
    @tasks = current_user.tasks.where(:due_date => Date.today)
    render :index
  end

  def upcoming
    @tasks = current_user.tasks.where('due_date > ?', Date.today)
    render :index
  end

  def show
    @task = current_user.tasks.where(:id => params['id']).first
  end

  def done
    delete
  end

  def delete
    task = current_user.tasks.find(params[:id])
    task.destroy
    if request.referer
      redirect_to request.referer
    else
      redirect_to root_path
    end
  end

  def create
    begin
      Rails.logger.info("params for create task: #{params}")
      Rails.logger.info("task_params: #{task_params}")
      @task = Task.create!(task_params)
      @task.add_tags
    rescue ActiveRecord::ActiveRecordError => e
      flash[:error] = e.message
      redirect_to new_task_path
      return
    end
    redirect_to task_path(@task)
  end

  def update
    task = current_user.tasks.find(params[:id])
    begin
      task.update!(task_params)
      task.update_tags
    rescue ActiveRecord::ActiveRecordError => e
      flash[:error] = e.message
      redirect_to edit_task_path(task)
      return
    end
    redirect_to task_path(task)
  end

  def task_params
    params.require('task').permit('title', 'description', 'due_date', 'input_tags': []).with_defaults(user_id: current_user.id)
  end
end
