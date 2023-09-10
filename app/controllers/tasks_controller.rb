class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def new
    @tags = Tag.all.sort_by {|t| t.title}.map {|t| [t.title, t.id]}
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
    @all_tags = Tag.all.sort_by {|t| t.title}.map {|t| [t.title, t.id]}
  end

  def show
    @task = Task.where(:id => params['id']).first
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    @tasks = Task.all
    render :index
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
    task = Task.find(params[:id])
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
    params.require('task').permit('title', 'description', 'input_tags': [])
  end
end
