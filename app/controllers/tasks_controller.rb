class TasksController < ApplicationController

  before_action :set_user_id, only: ['create']

  def index
    @tasks = current_user.tasks
  end

  def new
    @task = Task.new
  end

  def edit
    @task = current_user.tasks.find(params[:id])
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
      @task = Task.create!(task_params)
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
    rescue ActiveRecord::ActiveRecordError => e
      flash[:error] = e.message
      redirect_to edit_task_path(task)
      return
    end
    redirect_to task_path(task)
  end

  def task_params
    params.require('task').permit('title', 'description', 'due_date', 'user_id')
  end

  private

  def set_user_id
    Rails.logger.info("current_user_id: #{current_user.id}")
    params['task']['user_id'] = current_user.id
  end
end
