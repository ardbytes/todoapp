class TasksController < ApplicationController
  def index
  end

  def new
    @task = Task.new
  end

  def edit
    render 'wip'
  end

  def today
    render 'wip'
  end

  def upcoming
    render 'wip'
  end

  def show
    @task = Task.where(:id => params['id']).first
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

  def task_params
    params.require('task').permit('title', 'description', 'due_date')
  end
end
