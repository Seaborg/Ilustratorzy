class AdminController < ApplicationController
  before_filter :require_admin
  
  def index
  end
  
  def users
    @users = User.all
  end
  
  def delete
    @users = User.find(params[:id])
  end
  
  def destroy
    @users = User.find(params[:id])
    @users.destroy
    redirect_to(:action => 'users')
    
  end

end
