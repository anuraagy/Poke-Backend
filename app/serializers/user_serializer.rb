class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :bio, :phone_number, :rating, :created_at, :updated_at
end
   