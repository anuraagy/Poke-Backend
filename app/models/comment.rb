class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :reminder

  validates :content, presence: true

  def as_json(*)
    super.tap do |hash|
      hash["user_name"] = user.name
    end
  end
end
