class AccountController < ApplicationController
  model   :user
  layout  'application'

  def login
    case @request.method
      when :post
        if @session[:user] = User.authenticate(@params[:user_login], @params[:user_password])

          flash['notice']  = "Login successful"
          redirect_back_or_default :controller => "shows", :action => "list"
        else
          @login    = @params['user_login']
          flash['notice']  = "Login unsuccessful"
      end
    end
    render :layout=>'simple'
  end
  
  
  #this should be yanked
  def list
  	@users = User.find(:all)
  end
  
  def person_search
    if 0 == @params['criteria'].length
      @people = nil
    else
      @people = User.find(:all,
        :conditions => [ 'LOWER(login) LIKE ? OR LOWER(display_name) LIKE ?',
        '%' + @params['criteria'].downcase + '%', '%' + @params['criteria'].downcase + '%'  ])
      @mark_term = @params['criteria']
      render_without_layout
    end
  end
  
  def show
  	@user = User.find(@params[:id])
  end
  
  def edit
  	#if @session[:user].id == @params[:id]
  	  @user = User.find(@params[:id])
  	#else
  	#  flash['notice'] = "You can only edit your own account information."
  	#  redirect_back_or_default :action=>"show", :id=>@params[:id]
  	#end
  end
  
  
  def update
  	@user = User.find(@params[:id])
  	@user.update_attributes(@params[:user])
    	redirect_to :action => 'show', :id => @user
  end
  
  
  
  
  def signup
    case @request.method
      when :post
        @user = User.new(@params['user'])
        
        if @user.save      
          @session[:user] = User.authenticate(@user.login, @params['user']['password'])
          flash['notice']  = "Signup successful"
          redirect_back_or_default :controller => "shows", :action => "list"          
        end
      when :get
        @user = User.new
    end      
  end  
  
  def change_password
    @user = @session[:user]
    @session['message'] = nil
    case @request.method
    when :post
      unless @user.password_check?(@params['old_password'])
        flash['notice'] = 'That was not your existing password!'
      else
        #unless 5..40 === @params['new_password'].length
          #flash['notice'] = 'Your password must be between 5 and 40 charactors!'
        #else
          unless @params['new_password'] == @params['new_password_confirmation']
            flash['notice'] = 'Your password and password confirmation dont match!'
          else
            flash['notice'] = 'Your passord was changed successfully!' if @user.change_password(@params['new_password'])
          end
        #end
      end
      #redirect_back_or_default :controller => "account", :action => "change_password" 
      render :layout => "application"
    when :get
      render :layout => "application"
    end
  end
  
  def delete
    if @params['id']
      @user = User.find(@params['id'])
      @user.destroy
    end
    redirect_back_or_default :action => "welcome"
  end  
    
  def logout
    @session[:user] = nil
  end
  
  
  def welcome
  end
  
end
