class HomeController < ApplicationController

  def index
    render :plain => "Hello User!"
  end

  def welcome
    redirect_to tasks_path
  end
end
