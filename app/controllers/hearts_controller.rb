class HeartsController < ApplicationController
  before_filter :require_user, :only => [:create]
  before_filter :hearting_permissions, :only => [:create]
  
  def create
    @pic = Pic.find(params[:id])
    case current_user.heart_pic(@pic)
      when 1 then flash[:notice] = "Błąd kredek."
      when 2 then flash[:notice] = "Nie masz więcej kredek do rozdania."
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

private 
  
  def hearting_permissions
     @pic = Pic.find(params[:id])
     if current_user && ( !current_user.owns_pic?(@pic) || current_user.is_admin )
       return
     else
       flash[:notice] = 'Nie możesz dodać kredek samemu sobie :-)'
        respond_to do |format|
           format.html { redirect_to @pic }
           format.js { render :template => "/hearts/hearting_permissions.rjs" }
         end
     end
   end
   
end