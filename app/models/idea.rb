class Idea < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :title, :is_solved

  scope :solved, where("is_solved = true")
  scope :opened, where("is_solved = false")
end
