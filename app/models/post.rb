class Post < ActiveRecord::Base
  belongs_to :user
  default_scope { order(votes: :desc) }
  # TODO: Copy-paste your code from previous exercise
  validates_presence_of :user, :title, :url
  validates :title, uniqueness: { case_sensitive: false }
  validates :title, length: { minimum: 5 }
  validates :url, format: { with: /\..+\.*{2,3}/ }
end
