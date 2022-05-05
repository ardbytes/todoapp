class TasksController < ApplicationController
  def index
    redirect_to task_path('today')
  end

  def show
  end
end
