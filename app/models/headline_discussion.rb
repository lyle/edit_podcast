class HeadlineDiscussion < ActiveRecord::Base
  belongs_to :show
  belongs_to :headline
  acts_as_list :scope => :show
end
