class ReminderJob
    def initialize(reminder_id)
      @reminder_id = reminder_id
    end
    def perform
      Reminder.find(@reminder_id).send_reminder!
    end
  end