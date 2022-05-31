class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def today
    @tasks = Task.where(:due_date => Date.today)
    render :index
  end

  def upcoming
    @tasks = Task.where('due_date > ?', Date.today)
    render :index
  end

  def show
    @task = Task.where(:id => params['id']).first
  end

  def done
    delete
  end

  def delete
    task = Task.find(params[:id])
    task.destroy
    if request.referer
      redirect_to request.referer
    else
      redirect_to root_path
    end
  end

  def create
    begin
      @task = Task.create!(task_params)
    rescue ActiveRecord::ActiveRecordError => e
      flash[:error] = e.message
      redirect_to new_task_path
      return
    end
    redirect_to task_path(@task)
  end

  def update
    task = Task.find(params[:id])
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
    params.require('task').permit('title', 'description', 'due_date')
  end
end
