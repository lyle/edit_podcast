class ContributorsController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }


  def create
    @article = Article.find(params[:article_id])
    user_id = params[:id].split("_")[1]
    @user = User.find(user_id)
    role = params["role"]
    @contributor = Contributor.create(:role=>role, :user=>@user, :article=>@article)
    @article = Article.find(params[:article_id])
    @role = role
    render :action => "contributors_of_role"
  end
  
  def destroy
    contributor = Contributor.find(params[:id])
    @role = contributor.role
    @article = contributor.article
    contributor.destroy
    render :action => "contributors_of_role"
  end
  
  
  
  
  
  
  
  
  
  
  
end
