class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  after_create :create_inverse_relationship
  after_destroy :destroy_inverse_relationship

  private

  def create_inverse_relationship
    return if friend.friends.include?(user)
    friend.friendships.create(friend: user)
  end

  def destroy_inverse_relationship
    friendship = friend.friendships.find_by(friend: user)
    friendship.destroy if friendship
  end
end
