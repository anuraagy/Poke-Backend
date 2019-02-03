class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  attr_reader :current_user
  
  def authenticate_request!
    if verified_token?
      @current_user ||= User.find_by_email(auth_token[:email])
      render status: :unauthorized,
        json: { errors: ["Unauthorized request"] }  if @current_user.blank?
    else
      render status: :unauthorized, json: { errors: ["Unauthorized request"] }
    end
  end

  private

  def http_token
    @http_token ||= if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  def auth_token
    @auth_token ||= JSONWebToken.decode(http_token)
  end

  def verified_token?
    http_token && auth_token && auth_token[:email].present?
  end
end