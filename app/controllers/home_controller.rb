class HomeController < ApplicationController

  before_action :authenticate_user!

  def index
    render :plain => "Hello #{current_user.email.split("@").first}"
  end
end
