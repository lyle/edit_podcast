module ShowsHelper
  def displayParticipantsInRole(show,role)
    participants = show.participants.find_all_by_role(role)
    daText = image_tag("/images/timer_bgFFFFFF.gif",
                              {:size=>"15x15",
                               :alt=>"timer",
                               :id=>"#{role}RoleStatImg",
                               :align=>"right",
                               :style=>"display:none;"})
    daText = daText + role
	if participants.length > 0
	  daText = daText + "<ul>"
	   participants.each do |participant|
	     daText = daText + displayParticipant(participant)
	   end
	  daText = daText + "</ul>"
	end
	return daText;
  end

  def displayParticipant(participant)
  	daText = link_to_remote("X",:update => "participant_#{participant.id}",
  	                            :before=> {visual_effect(:pulsate, "participant_#{participant.id}", :duration => 4),
  	                                       "$('#{participant.role}RoleStatImg').style.display='block'"},
  								 :url=> {:action=>"destroy_participant", :id=>participant.id})
    daText = daText + " " + participant.user.name
    return content_tag( 'li', daText, {:id=>"participant_#{participant.id}", :class=>"personName"})
  end
end

