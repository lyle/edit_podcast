module HeadlineDiscussionsHelper
  
  def order
      @order = params[:list]
      render :partial => 'list'
  end
  
end
