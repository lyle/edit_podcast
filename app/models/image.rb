class Image < ActiveRecord::Base
  has_and_belongs_to_many :articles
  has_and_belongs_to_many :shows
  belongs_to :owner,
             :class_name => "User",
             :foreign_key => "user_id"
             
  #these are very bad, but I can't duplicate the relationship names.
    has_many :show_parents,
          :class_name => "Show",
          :foreign_key => "teaser_id"
    has_many :article_parents,
          :class_name => "Article",
          :foreign_key => "teaser_id"
end
