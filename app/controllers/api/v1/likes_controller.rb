class Api::V1::LikesController < Api::V1::BaseController
  before_action :authenticate_request!

  def create
    like = Like.new(comment_params)

    if like.user != current_user
      render status: :unauthorized, json: { errors: ["You are not authorized to create this like!"] }
    elsif like.save
      render status: :ok, json: { success: true }
    else
      render status: :bad_request, json: { errors: like.errors.full_messages }
    end
  end

  def destroy
    like = Like.find_by(id: params[:id])

    if like.blank?
      render status: :bad_request, json: { errors: ["There was no like with that id!"] }
    elsif like.user != current_user
      render status: :unauthorized, json: { errors: ["You are not authorized to delete this like!"] }
    elsif like.destroy
      render status: :ok, json: { success: true }
    else
      render status: :bad_request, json: { errors: ["There was a problem trying to delete your like!"] }
    end
  end

  private

  def comment_params
    params.permit(:user_id, :reminder_id)
  end
end
