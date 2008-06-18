class Question < ActiveRecord::Base
  has_many :answers,
           :dependent => true
  belongs_to :user
  has_and_belongs_to_many :shows
end
