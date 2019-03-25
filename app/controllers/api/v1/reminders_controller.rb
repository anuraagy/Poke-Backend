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
    params.require([:ids, :ratings])
    ids = params[:ids]
    ratings = params[:ratings]
    if !ratings.is_a?(Array) || !ids.is_a?(Array) || ratings.length != ids.length
      render status: :bad_request, json: { errors: ['ids/ratings should be arrays of same size'] }
      return
    end
    ratings.each do |rating|
      if rating.to_i < 0 || rating.to_i > 5
        render status: :bad_request, json: { errors: ['rating should be between 0 and 5'] }
        return
      end
    end

    ids.zip(ratings).each do |id, rating|
      reminder = Reminder.find(id.to_i)
      if reminder.present?
        if reminder.creator == current_user
          reminder.update(caller_rating: rating.to_i)
        elsif reminder.caller == current_user
          reminder.update(creator_rating: rating.to_i)
        end
      end
    end
    render status: :ok, json: { success: true }
  end

  def unrated
    reminders = Reminder.where(caller: current_user).where(creator_rating: nil)
      .or(Reminder.where(creator: current_user).where(caller_rating: nil))
      .where(status: 'triggered')
    render status: :ok, json: reminders
  end


  private

  def reminder_params
    params.permit(:title, :description, :status, :public, :creator_id, :caller_id, :will_trigger_at, :push)
  end
end
