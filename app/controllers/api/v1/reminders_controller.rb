class Api::V1::RemindersController < Api::V1::BaseController
  before_action :authenticate_request!

  def create
    reminder = Reminder.new(reminder_params)

    if reminder.save
      render status: 200, json: { reminder: reminder.as_json }
    else
      render status: 400, json: { errors: reminder.errors.full_messages }
    end
  end

  def update
    reminder = Reminder.find(params[:id])

    if reminder.creator != current_user
      render status: 401, json: { success: false, message: "You don't have access to this reminder!" }
      return
    end

    if reminder.triggered?
      render status: 400, json: { success: false, message: "You can't edit a reminder that has been triggered!" }
      return
    end

    if reminder.update(reminder_params)
      render status: 200, json: { reminder: reminder.as_json }
    else
      render status: 400, json: { errors: reminder.errors.full_messages }
    end
  end

  def destroy
    reminder = Reminder.find(params[:id])

    if reminder.creator != current_user
      render status: 401, json: { success: false, message: "You don't have access to this reminder!" }
      return
    end

    if reminder.triggered?
      render status: 400, json: { success: false, message: "You can't delete a reminder that has been triggered!" }
      return
    end

    if reminder.destroy
      render status: 200, json: { success: true }
    else
      render status: 400, json: { success: false, message: "There was an error!" }
    end
  end

  private

  def reminder_params
    params.permit(:description, :status, :public, :creator_id, :caller_id, :will_trigger_at)
  end
end