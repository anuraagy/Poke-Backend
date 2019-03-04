class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :bio, :phone_number, :rating, :created_at, :updated_at, :rating

  def rating
    (Reminder.where(creator: self).where.not(creator_rating: nil).sum(:creator_rating)
    +
    Reminder.where(caller: self).where.not(caller_rating: nil).sum(:caller_rating)
    )
    / (
    Reminder.where(creator: self).where.not(creator_rating: nil).count
    +
    Reminder.where(caller: self).where.not(caller_rating: nil).count
    )
  end
end
   