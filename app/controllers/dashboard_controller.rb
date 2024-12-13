# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.recent_hundred
  end

  def show
    @user = User.find(params[:id])
  end

end
