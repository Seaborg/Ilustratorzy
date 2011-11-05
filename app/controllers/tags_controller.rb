class TagsController < ApplicationController
  before_filter :require_user, :only => [:create, :destroy]
  before_filter :tagging_permissions, :only => [:create]
  before_filter :destroy_permissions, :only => [:destroy]
  
  def pics
    @tag = Tag.find_by_name(params[:tag])
    @users = User.find_by_name(params[:login])
    @pics = @tag.pics
  end
  
  def create
      tag_name = params[:tag]['name'];
      flash[:pic_id] = flash[:pic_id]
      if tag_name == '' || tag_name == nil
        flash[:notice] = "Tag nie może być pusty."
        @errorCode = 1;
      else
        @tag = Tag.find_or_create_by_name(tag_name)
        if Tagging.find(:first, :conditions => { :pic_id=>flash[:pic_id], :tag_id=>@tag.id}) != nil
          flash[:notice] = "Ta grafika już posiada swój Tag."
          @errorCode = 2;
        else
          @tagging = Tagging.new("pic_id"=>flash[:pic_id], "created_at"=>Time.now,"user_id"=>current_user.id,"tag_id"=>@tag.id) 
          if @tagging.save
            flash[:notice] = "Dodano Tag."
            @errorCode = 0;
          else
            flash[:notice] = "Błąd dodawania Tagu do grafiki."
            @errorCode = 3;
          end
        end
      end
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end  
   end
   
    def destroy
        if Tagging.find_by_tag_id(@tagging.tag_id) == nil
             Tag.find(@tagging.tag_id).destroy
        end
        @tagging.destroy
         flash[:notice] = 'Tag usunięty.'
        respond_to do |format|
          format.html { redirect_to @pic }
          format.js
        end
     end
   
private 
   
   def tagging_permissions
      @pic = Pic.find(flash[:pic_id])
      if current_user && (@pic.user.friends.exists?(current_user.id) || current_user.id == @pic.user_id || current_user.is_admin)
        return
      else
        flash[:notice] = 'Możesz dodać Tag tylko osobom które podążyły za Tobą.'
        redirect_to :back
      end
   end
   
   def destroy_permissions
     @tagging = Tagging.find(params[:id])
     @pic = Pic.find(@tagging.pic_id)
     unless current_user.id == @tagging.user_id || current_user.id == @pic.user_id || current_user.is_admin
       flash[:notice] = 'Nie masz uprawanień do usunięcia tego Tagu.'
       redirect_to :back
     end
   end
   
end