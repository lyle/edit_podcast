# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def linkToShowPreview(show)  
  	if show.status == "live"
        return link_to('View', view_show(show) )
    else
        return link_to('Preview', preview_show(show) )
    end
  end

  def displayImageThumb image
      daHtml = "<div class=\"imageShell\">"
      daHtml += "<img src=\"/images/#{image.thmb.src}\" width=\"#{image.thmb.width}\" height=\"#{image.thmb.height}\" />"
      daHtml += "</div>"
      return daHtml
  end
  
  def user?
    !@session[:user].nil?
  end
  
  def userName
    @session[:user].login
  end
  
  def showImageList
    message = ""
    imageListImageID = ""
    for image in @obj.images
      imageListImageID = "imageListImageID_#{image.id}"
      message += "<div class=\"imageBlock\" id=\"#{imageListImageID}\">\r"
      message += "\t<div class=\"imageBox\">\r\t\t"
      message +=  link_to_remote "Delete this Image", :update => imageListImageID,
               :url => {:controller => 'images', :action => "destroy_return_none", :id => image.id },
               :success => "new Effect.Fade('#{imageListImageID}');",
               :before => "this.style.display='none'"
      message += "<br />\r\t\t<img src=\"#{@obj.view_url}#{image.name}\" width=\"150\" />"
      message += "\r\t\t<div class=\"imageStats\">#{image.width}x#{image.height}</div>"
      message += "\r\t\t<div class=\"imageName\">[#{image.name}|SomeText]</div>"
      if image.alternative_text == ''
        image.alternative_text = 'Please enter something!'
      end
      message += "\r\t\t<div>AltText: <span id=\"imageAltText_#{image.id}\">#{image.alternative_text}</span></div>"
      message += in_place_editor("imageAltText_#{image.id}", :size => 20, :url => {:controller => 'images', :action => 'edit_alt_text', :id => image})
      message += "\r\t</div>"
      message += "<div class=\"imageName\">#{image.name}</div>\r</div>"
    end
    message += "<div id=\"loadingimage\" style=\"display:none;\"><img src=\"/images/timer_bgFFFFFF.gif\" width=\"15\" height=\"15\"/>...uploading.</div>"
    return message
  end
  
  def showImageForm(obj, object_type)
    message = "<div id=\"image_upload\" style=\"display:none\">"
    message += form_tag_with_upload_progress({:controller => 'images', :action => 'upload_and_assign'}, 
            {:begin => "new Effect.Appear('loadingimage');Effect.BlindUp($('image_upload'));",
             :finish => "reloadImageList();new Effect.Fade('upload_status');"},
            {:controller => 'images'})
    if object_type == "show"
    	message += "<input type=\"hidden\" name=\"show_id\" value=\"#{obj.id}\">"
    end
    if object_type == "article"
    	message += "<input type=\"hidden\" name=\"article_id\" value=\"#{obj.id}\">"
    end
    message += link_to_function "X", "toggleWithBlind('image_upload');", {:class=>'closebutton'}
    message += "<label for=\"image[tmp_file]\">Image to Upload:</label>"
    message += "<input type=\"file\" size=\"40\" class=\"file\" name=\"image[tmp_file]\" /><br />"
    message += "<label for=\"image[alternative_text]\">Alternative Text</label>"
    message += "<input type=\"text\" size=\"40\" name=\"image[alternative_text]\" /><br />"
    message += submit_tag "Upload", :class=>"submit"
    message += end_form_tag
    message += "</div>"
    return message
  end 
  
  def teaserForm(obj,object_type)
  	# an object independent teaser display and form upload
    message = "<div id=\"teaser_form\" style=\"display:none\">"
    message += form_tag({:controller => 'images', :action => 'upload_teaser'},
                {:multipart => true,:target =>'teaser_image_upload',:onsubmit => "new Effect.BlindUp($('teaser_form'));$('teaser_image').innerHTML='<img src=\"/images/timer_bgFFFFFF.gif\" width=\"15\" height=\"15\"/>...uploading.'"})
    message += "<iframe id=\"teaser_image_upload\" name=\"teaser_image_upload\" src=\"\" style=\"width:0px;height:0px;border:0\"></iframe>"
    if object_type == "show"
    	message += "<input type=\"hidden\" name=\"show_id\" value=\"#{obj.id}\">"
    end
    if object_type == "article"
    	message += "<input type=\"hidden\" name=\"article_id\" value=\"#{obj.id}\">"
    end
    message += link_to_function "X", "toggleWithBlind('teaser_form');", {:class=>'closebutton'}
    message += "<label for=\"image[tmp_file]\">Teaser:</label>"
    message += "<div class=\"beta\"><h3>Beta Warning</h3> The teaser must be a JPG, 150px wide by 100px tall.</div>"
    message += "<input type=\"file\" size=\"40\" class=\"file\" name=\"image[tmp_file]\" /><br />"
    message += submit_tag "Upload", :class=>"submit"
    message += end_form_tag
    message += "</div>"
    return message
  end

  def teaserOrAddLink(obj)
  	#this replaces showTeaserOrAddLink
    message = "<div id=\"teaser_image\">"
    if !obj.teaser.nil? 
      t = Time.now
      
      # imageSrc = url_for(:controller => 'images', :action => 'showimage', :id => obj.teaser.id)
      # we are going to load the image from cocoon, because the image reader is much faster then the rails solution
      imageSrc = "#{obj.view_url}#{obj.teaser.name}"
      
      # display a linked teaser_image that calls a function to show the teaser form
      # message += link_to_function "<img src=\"#{imageSrc}?#{t.to_i}\" width=\"150\" height=\"100\" /><span>change</span>", "toggleWithBlind('teaser_form');", "class" => "change"
      message += link_to_function "<img src=\"#{imageSrc}\" width=\"150\" height=\"100\" /><span>change</span>", "toggleWithBlind('teaser_form');", "class" => "change"
    else
      message += "No Teaser Image Assigned<br />"
      message += link_to_function "Upload One", "toggleWithBlind('teaser_form');"
    end
    return message + "</div>"
  end
  
  def showTeaserOrAddLink
  	#this is being replaced with a generic teaser or add link: teaserOrAddLink
    message = ""
    if !@show.teaser.nil? 
      t = Time.now
      imageSrc = url_for(:controller => 'images', :action => 'showimage', :id => @show.teaser.id)
      # display a linked teaser_image that calls a function to show the teaser form
      message += link_to_function "<img src=\"#{imageSrc}?#{t.to_i}\" width=\"150\" height=\"100\" /><span>change</span>", "toggleWithBlind('teaser_form');", "class" => "change"
    else
      message += "No Teaser Image Assigned<br />"
      message += link_to_function "Upload One", "toggleWithBlind('teaser_form');"
    end
    return message
  end
end
