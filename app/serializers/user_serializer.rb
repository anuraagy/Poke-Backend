class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :bio, :phone_number, :rating, :created_at, :updated_at, :rating

  def rating
    count = Reminder.where(creator: object).where.not(creator_rating: nil).where.not(creator_rating: 0).count +
            Reminder.where(caller: object).where.not(caller_rating: nil).where.not(creator_rating: 0).count + 1
    return 0 if count == 0
    sum = Reminder.where(creator: object).where.not(creator_rating: nil).sum(:creator_rating) +
          Reminder.where(caller: object).where.not(caller_rating: nil).sum(:caller_rating)
    sum.to_f / count.to_f
  end
end
   