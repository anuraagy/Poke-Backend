class Api::V1::RemindersController < Api::V1::BaseController
  include TwilioHelper
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
      job = Delayed::Job.find_by_id(reminder.job_id)
      if job.present?
        job.update(run_at: reminder.will_trigger_at)
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
      job = Delayed::Job.find_by_id(reminder.job_id)
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

  def rating
    params.require(:id, :rating)
    reminder = Reminder.find(params[:id])
    if reminder.present? && (reminder.creator == current_user || reminder.caller == current_user)
              && params[:rating].is_a?(Integer)
      if reminder.creator == current_user
        reminder.caller_rating = params[:rating]
      elsif reminder.caller == current_user
        reminder.creator_rating = params[:rating]
      end
      render status: :ok json: { success: true }
    else
      render status: :bad_request,
        json: { errors: ['Reminder does not exist or you do not have access'] }
    end
  end

  def complete
    p = params.require(:id).permit(:rating)
    reminder = Reminder.find(p[:id])
    if reminder.present? && (reminder.creator == current_user || reminder.caller == current_user)
      if reminder.proxy_session_sid.present?
        TwilioHelper::close_proxy_session(proxy_session_sid)
        reminder.update(:proxy_session_sid, nil)
      end

      if p.key?(:rating) && p[:rating].is_a?(Integer)
        if reminder.creator == current_user
          reminder.caller_rating = p[:rating]
        elsif reminder.caller == current_user
          reminder.creator_rating = p[:rating]
        end
      end
      render status: :ok json: { success: true }
    else
      render status: :bad_request,
        json: { errors: ['Reminder does not exist or you do not have access'] }
    end
  end

  private

  def reminder_params
    params.permit(:title, :description, :status, :public, :creator_id, :caller_id, :will_trigger_at, :push)
  end
end
