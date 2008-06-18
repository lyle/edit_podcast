module AdminHelper
  def displayGroup(group)
  	if group.users.count < 1
  		membersOrDelete = " " + link_to_remote("X",
  										:update => "group_#{group.id}",
  										:confirm => "Are you sure you want to delete this group?",
  										:url=> {:action=>"destroy_group", :id=>group.id})
  	else
  		membersOrDelete = " (#{group.users.count} #{group.users.count > 1 ? 'member'.pluralize : 'member'})"
  	end
  	daText = link_to("#{group.name}", :action=>"group_detail", :id=>group.id) + membersOrDelete
    return content_tag( 'li', daText, {:id=>"group_#{group.id}"})
  end
end