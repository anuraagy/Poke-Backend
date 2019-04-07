class Api::V1::CommentsController < Api::V1::BaseController
  before_action :authenticate_request!

  def create
    comment = Comment.new(comment_params)

    if comment.user != current_user
      render status: :unauthorized, json: { errors: ["You are not authorized to create this comment!"] }
    elsif comment.save
      render status: :ok, json: { success: true }
    else
      render status: :bad_request, json: { errors: comment.errors.full_messages }
    end
  end

  def destroy
    comment = Comment.find_by(id: params[:id])

    if comment.blank?
      render status: :bad_request, json: { errors: ["There was no comment with that id!"] }
    elsif comment.user != current_user
      render status: :unauthorized, json: { errors: ["You are not authorized to delete this comment!"] }
    elsif comment.destroy
      render status: :ok, json: { success: true }
    else
      render status: :bad_request, json: { errors: ["There was a problem trying to delete your comment!"] }
    end
  end

  private

  def comment_params
    params.permit(:content, :user_id, :reminder_id)
  end
end
