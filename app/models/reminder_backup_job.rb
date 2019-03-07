class ReminderBackupJob
    def initialize(reminder_id)
      @reminder_id = reminder_id
    end
    def perform
      Reminder.find(@reminder_id).send_backup_reminder
    end
  end