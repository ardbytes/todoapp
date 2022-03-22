class HomeController < ApplicationController

  before_action :authenticate_user!, :only => [:index]

  def index
    render :plain => "Hello #{current_user.email.split("@").first}"
  end

  def welcome
  end
end
