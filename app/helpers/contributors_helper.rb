module ContributorsHelper
  def displayContributorsInRole(article,role)
    contributors = article.contributors.find_all_by_role(role)
    daText = image_tag("/images/timer_bgFFFFFF.gif",
                              {:size=>"15x15",
                               :alt=>"timer",
                               :id=>"#{role}RoleStatImg",
                               :align=>"right",
                               :style=>"display:none;"})
    daText = daText + role
	if contributors.length > 0
	  daText = daText + "<ul>"
	   contributors.each do |contributor|
	     daText = daText + displayContibutor(contributor)
	   end
	  daText = daText + "</ul>"
	end
	return daText;
  end

  def displayContibutor(contributor)
  	daText = link_to_remote("X",:update => "contributor_#{contributor.id}",
  	                            :before=> {visual_effect(:pulsate, "contributor_#{contributor.id}", :duration => 4),
  	                                       "$('#{contributor.role}RoleStatImg').style.display='block'"},
  								 :url=> {:controller=>"contributors", :action=>"destroy", :id=>contributor.id})
    daText = daText + " " + contributor.user.name
    return content_tag( 'li', daText, {:id=>"contributor_#{contributor.id}", :class=>"personName"})
  end
end
