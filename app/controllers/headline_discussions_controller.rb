class HeadlineDiscussionsController < ApplicationController
  
  def create
    @discussion = HeadlineDiscussion.new(:show_id => params[:show_id], :headline_id => params[:headline_id])
    if @discussion.save
      @headline = Headline.find(params[:headline_id])
      flash[:notice] = 'Headline was successfully assigned to this show.'
    else
      flash[:notice] = 'Things went badly.'
    end
  end
  
  def destroy
    @discussion = HeadlineDiscussion.find(params[:id])
    @show = Show.find(@discussion.show)
    
    @headline = @discussion.headline
    @oldid = params[:id]
    if @discussion.destroy
      flash[:notice] = 'The News item has been unlinked from this show.'
    else
      flash[:notice] = 'You tried to unlink the news item from thsi show, but...'
    end
    @headlineOrfins = Headline.find_by_sql(" SELECT headlines.* FROM headlines LEFT OUTER JOIN  headline_discussions ON (headlines.id = headline_discussions.headline_id) WHERE headline_discussions.id IS NULL")
    
  end
    
  
  def order
    if request.xhr?
      params[:headlines].each_with_index { |id,idx| HeadlineDiscussion.update(id, :position => idx) }
      flash[:notice] = 'Updated sort order of news'
    else
      render :text=>'Not updated!', :layout=>false
      return
    end
  end
end
