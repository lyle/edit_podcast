class ArticlesController < ApplicationController
  include LoginSystem 
  
  layout  'application'
  before_filter :login_required
  
  in_place_edit_for :article, :slug
  
  helper :Contributors 
  
  def index
    list
    render_action 'list'
  end

  def list
    #@articles = Article.find_all
    @article_pages, @articles = paginate :article, :per_page => 20, :order => "publishdate DESC"
    @user = @session[:user]
  end

  def new
    @article = Article.new
    @user = @session[:user]
  end

  def create
    @article = Article.new(@params[:article])
    @article.owner = @session[:user]
    if @article.save
      flash['notice'] = 'Article was successfully created.'
      redirect_to :action => 'edit', :id => @article
    else
      render_action 'new'
    end
  end

  def edit
    @article = Article.find(@params[:id])
    @geeks = Group.find(:first, :conditions => ["name = 'Geeks'"], :include => :users ).users
    @user = @session[:user]
  end

  def update
    @article = Article.find(@params[:id])
    if @article.update_attributes(@params[:article])
      flash['notice'] = 'Article was successfully updated.'
    else
      flash['notice'] = 'Something did not save!'
    end
    redirect_to :action => 'edit', :id => @article.id
  end

  def destroy
    Article.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  
  def set_article_slug
    @article = Article.find(params[:id])
    @article.slug = params[:value]
    @article.save
    @article.reload
    render :text => @article.send(:slug)
  end
end
