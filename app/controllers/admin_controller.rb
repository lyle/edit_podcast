class AdminController < ApplicationController

  layout  'account'

  def index
    redirect_to :action => 'groups'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }

  def groups 
    @groups = Group.find(:all, :include=>:users)
  end

  def group_detail
    @group = Group.find(params[:id])
  end

  def create_group
    @group = Group.new(params[:group])
    @group.creator = @session[:user]
    @group.save
  end

  def edit_group
    @group = Group.find(params[:id])
  end

  def update_group
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      flash[:notice] = 'Group was successfully updated.'
      redirect_to :action => 'group_detail', :id => @group
    else
      render :action => 'edit_group'
    end
  end

  def destroy_group
    group = Group.find(params[:id])
    group.destroy
    @groups = Group.find(:all, :include=>:users)
  end
  
  def add_member_to_group
    @group = Group.find(params[:group_id])
    user_id = params[:id].split("_")[1]
    @user = User.find(user_id)
    if @group.users.include?(@user) 
      render :text=>'nope'
    else
	    @group.users<<@user
    end
  end
  def remove_member
    @group = Group.find(params[:group_id])
    @user = User.find(params[:user_id])
    @group.users.delete(@user)
  end
end
