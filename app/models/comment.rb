class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :reminder

  validates :content, presence: true
end
