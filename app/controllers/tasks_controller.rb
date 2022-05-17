class TasksController < ApplicationController
  def index
    redirect_to task_path('today')
  end

  def new
    @task = Task.new
  end

  def show
  end

  def create
    redirect_to task_path('today')
  end
end
