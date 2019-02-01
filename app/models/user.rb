class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :active, presence: true
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0 , less_than_or_equal_to: 5 }

  def self.login_or_create_from_facebook(facebook_params)
    return unless valid_fb_authtoken?(facebook_params[:facebook_token], facebook_params[:email])

    user = User.find_by(facebook_token: facebook_params[:facebook_token])

    if user.blank?
      user = User.find_by_email(facebook_params[:email])

      if user.present?
        user.facebook_token = facebook_params[:facebook_token]
      else
        user = User.new(facebook_params)
        user.password = facebook_params[:facebook_token]
        user.facebook_token = facebook_params[:facebook_token]
      end
    end

    user
  end

  
  def self.valid_fb_authtoken?(fb_authtoken, email)
    response = HTTParty.get("https://graph.facebook.com/me?"\
      "access_token=#{fb_authtoken}&fields=email")
    response["email"].present? && response["email"] == email
  end
end
