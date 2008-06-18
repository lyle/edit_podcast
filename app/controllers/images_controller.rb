require 'RMagick'

class ImagesController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def showimage
    @image = Image.find(@params[:id])
    send_data @image.data, :type => @image.mimetype, :disposition => 'inline'
  end
  def showthumb
    @image = Image.find(@params[:id])
    pic = Magick::Image.from_blob(@image.data)[0]
    thmb = pic.resize(100,20 ,Magick::GaussianFilter ,0)

    send_data thmb.to_blob, :type => pic.mime_type, :disposition => 'inline'
  end
 def thumb
   @params["width"] = 100
   @params["height"] = 100
   render_resized_image 
 end
 def render_resized_image
     @image=Image.find(@params["id"])
     maxw = @params["width"] != nil ? @params["width"].to_i : 90
     maxh = @params["height"] != nil ? @params["height"].to_i : 90
     aspectratio = maxw.to_f / maxh.to_f
     pic = Magick::Image.from_blob(@image.data)[0]
     picw = pic.columns
     pich = pic.rows
     picratio = picw.to_f / pich.to_f
     if picratio > aspectratio then
       scaleratio = maxw.to_f / picw
     else
       scaleratio = maxh.to_f / pich
     end
    #breakpoint
    thumb = pic.resize(scaleratio)
    send_data thumb.to_blob, :type => pic.mime_type.to_s, :disposition => 'inline'
  end

  def list
    @image_pages, @images = paginate :image, :per_page => 10
  end

  def show
    @image = Image.find(@params[:id])
  end

  def new
    @image = Image.new
  end
  
  def create
    load_multiform_file_info
    @image = Image.new(@params[:image])
    @image.owner = @session[:user]
    if @image.save
      flash['notice'] = 'Image was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @image = Image.find(@params[:id])
  end
  def edit_alt_text 
    @image = Image.find(@params[:id])
    @image.alternative_text = @params[:value]
    if @image.save 
      render_text @image.alternative_text
    else
      render_text 'error, not saved'
    end
  end
  def update
    load_multiform_file_info
    @image = Image.find(@params[:id])
    if @image.update_attributes(@params[:image])
      flash['notice'] = 'Image was successfully updated.'
      redirect_to :action => 'show', :id => @image
    else
      render_action 'edit'
    end
  end
  
  def display_teaser
  	# pending solution for generic "display_show_teaser"
  	
    if @params['object_type'] == "article"
      obj = Article.find(@params[:id])
	end
    if @params['object_type'] == "show"
      obj = Article.find(@params[:id])
	end
    @image = obj.teaser
    render_partial "display_teaser", obj
  end
  
  def display_show_teaser
  	# a generic solution must be found for this.
    @show = Show.find(@params[:id])
    @image = @show.teaser
    render_partial "display_show_teaser"
  end
  def new_teaser
    @show = Show.find(@params['show_id'])
    @image = Image.new
  end
  
  def upload_teaser
  	#possible problem - teaser could be anything.. should only be png or jpg
  	#newer object generic teaser uploader, replaces show specific: "upload_show_teaser"
    @message = 'File Updated'
    # Updates the existing show teaser or creates a teaser for the show
    load_multiform_file_info
    
    #make the teaser name lowercase and name it "teaser.jpg" or "teaser.png"
    @params['image']['name'].downcase!
    @params['image']['name'].gsub!(/^.*\.(jpg|png)/,'teaser.\1')
    
    if !@params['show_id'].nil?
      @obj = Show.find(@params['show_id'])
    end
    if !@params['article_id'].nil?
      @obj = Article.find(@params['article_id'])
    end

    if @obj.teaser.nil?
      #this show/article dose not have a teaser, let's make one
      @image = Image.new(@params[:image])
      @image.owner = @session[:user]
      if @image.save
        @obj.teaser = @image
        @obj.save
        flash['notice'] = 'Teaser added.'
        redirect_to :action => 'done_uploading_teaser'
      else
        flash['notice'] = 'Something went wrong, no teaser was uploaded and/or saved.'
        redirect_to :action => 'done_uploading_teaser'
      end
    else
      #this show/article has a teaser, let's update it
      @image = @obj.teaser
      @image.owner = @session[:user]
      if @image.update_attributes(@params[:image])
        flash['notice'] = 'Teaser updated.'
        redirect_to :action => 'done_uploading_teaser'
      else
        flash['notice'] = 'Something went wrong, the teaser was not modified.'
        redirect_to :action => 'done_uploading_teaser'
      end
    end
  end
  
#  def upload_show_teaser
#  	#this is show specific and should be replaced with object generic teaser uploader: 'upload_teaser'
#    @message = 'File Updated'
#    # Takes image file and the id of a show
#    # Updates the existing show teaser or creates a teaser for the show
#    load_multiform_file_info
#    @show = Show.find(@params['show_id'])
#    if @show.teaser.nil?
#      #this show dose not have a teaser, let's make one
#      @image = Image.new(@params[:image])
#      if @image.save
#        flash['notice'] = 'Image was successfully created.'
#        @show = Show.find(@params['show_id'])
#        @show.teaser = @image
#        @show.save
#        redirect_to :action => 'done_uploading_teaser', :id => @show
#      else
#        render_text 'an error occured while saving a new teaser'
#      end
#    else
#      #this show has a teaser, let's update it
#      @image = @show.teaser
#      if @image.update_attributes(@params[:image])
#        flash['notice'] = 'Image was successfully updated.'
#        redirect_to :action => 'done_uploading_teaser', :id => @show
#      else
#        render_text 'an error occured while updateing the teaser'
#      end
#    end
#  end
  
  def flash_upload_and_assign_to_article
    
      logger.info("flash_upload_and_assign_to_article called")
    @article = Article.find(@params['article_id'])
    @image = Image.new
#    data = params[:Filedata]
#    name = params[:Filename]
    @image.name = @params[:Filename].gsub(/[^a-zA-Z0-9.]/, '_')
    @image.data = @params[:Filedata].read
    pic = Magick::Image.from_blob(@image.data)[0]
    @image.width = pic.columns
    @image.height = pic.rows
    @image.mimetype = pic.mime_type
    @image.name.downcase!
    @image.name.gsub!(/^teaser\.(jpg|png)/, 'teaser_extra.\1')
    if @image.save
      @article.images.each do |img|
          if @image.name == img.name
              @article.images.delete(img)
              img.destroy
          end
      end
      @article.images<<@image
    end

#    render :nothing => true
    render :text => "#{@article.title}"
  end
  
  upload_status_for  :upload_and_assign
  
  def upload_and_assign
    # Takes image file and the id of a show or an article
    # saves the image and assigns it to a show or an article
    load_multiform_file_info
    
    @params['image']['name'].downcase!
    @params['image']['name'].gsub!(/^teaser\.(jpg|png)/, 'teaser_extra.\1')
    
    @image = Image.new(@params[:image])
    if @image.save
        if !@params['show_id'].nil?
            @obj = Show.find(@params['show_id'])
        end 
        if !@params['article_id'].nil?
            @obj = Article.find(@params['article_id'])
        end 
        @obj.images.each do |img|
            if @image.name == img.name
                @obj.images.delete(img)
                img.destroy
            end
        end
        @obj.images<<@image
        #if @obj.save
        		finish_upload_status "'Image Assigned'"
        #else
        	#	finish_upload_status "'Image Not Assigned'"
        #end
    else
    		finish_upload_status "'Image Not Saved'"
    end
  end


  def show_image_list
    if !@params['show_id'].nil?
      @obj = Show.find(@params['show_id'])
    end
    if !@params['article_id'].nil?
      @obj = Article.find(@params['article_id'])
    end
    render_partial "show_image_list"
  end
  
# assumed depricated 2006-03-28 11:03pm
#  def create_teaser
#    load_multiform_file_info
#    @image = Image.new(@params[:image])
#    if @image.save
#      flash['notice'] = 'Image was successfully created.'
#      @show = Show.find(@params['show_id'])
#      @show.teaser = @image
#      @show.save
#      redirect_to :action => 'done_uploading_teaser', :id => @show
#    else
#      render_action 'new_teaser'
#    end
#  end
#  
#  def update_teaser
#    load_multiform_file_info
#    @show = Show.find(@params['show_id'])
#    @image = Image.find(@params[:id])
#    if @image.update_attributes(@params[:image])
#      flash['notice'] = 'Image was successfully updated.'
#      redirect_to :action => 'done_uploading_teaser', :id => @show
#    else
#      render_action 'edit_teaser'
#    end
#  end
  
  def done_uploading_teaser
  	render :layout => false
  	#These objects are not being used.
  	#if !@params['article_id'].nil?
  	#	@obj = Article.find(@params['article_id'])
  	#end
  	#if !@params['show_id'].nil?
  	#	@obj = Show.find(@params['show_id'])
  	#end
  end
  
  def edit_teaser
    @show = Show.find(@params['show_id'])
    @image = @show.teaser
  end

  def destroy
    Image.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
  def destroy_return_none
    Image.find(@params[:id]).destroy
    render_text ''
  end
  
  
  def load_multiform_file_info
    logger.info("load_multiform_file_info called")
    @params['image']['name'] = @params['image']['tmp_file'].original_filename.gsub(/[^a-zA-Z0-9.]/, '_')
    @params['image']['data'] = @params['image']['tmp_file'].read
    pic = Magick::Image.from_blob(@params['image']['data'])[0]
    @params['image']['width'] = pic.columns
    @params['image']['height'] = pic.rows
   # @params['image']['aspectratio'] = pic.columns.to_f / pic.rows.to_f
    @params['image']['mimetype'] = pic.mime_type
    @params['image'].delete('tmp_file')
  end
end
