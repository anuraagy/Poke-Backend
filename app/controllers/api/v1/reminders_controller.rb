class Api::V1::RemindersController < Api::V1::BaseController
  before_action :authenticate_request!

  def index
    render status: :ok, json: Reminder.where(creator: current_user)
  end

  def show
    reminder = Reminder.find(params[:id])
    if reminder.creator != current_user
      render status: :unauthorized, json: { success: false, message: "You don't have access to this reminder!" }
      return
    end

    render status: :ok, json: { reminder: reminder }
  end

  def create
    reminder = Reminder.new(reminder_params)

    if reminder.save
      job = Delayed::Job.enqueue(ReminderJob.new(reminder.id), 0, reminder.will_trigger_at)
      reminder.update_attribute(:job_id, job.id)
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
      job = Delayed::Job.find(reminder.job_id)
      if job.present?
        job.update_attribute(:run_at, reminder.will_trigger_at)
      end
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
      job = Delayed::Job.find(reminder.job_id)
      if job.present?
        job.destroy
      end
      render status: 200, json: { success: true }
    else
      render status: 400, json: { success: false, message: "There was an error!" }
    end
  end

  def start

  end

  def complete

  end

  private

  def reminder_params
    params.permit(:title, :description, :status, :public, :creator_id, :caller_id, :will_trigger_at)
  end
end
