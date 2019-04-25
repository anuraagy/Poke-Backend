require 'twilio-ruby'

module TwilioHelper
  @client = Twilio::REST::Client.new(
    Rails.application.credentials.twilio_acct_sid,
    Rails.application.credentials.twilio_auth_token
  )

  def self.create_proxy_session
    @client.proxy
      .services(Rails.application.credentials.twilio_service_sid)
      .sessions
      .create(ttl: 180)
  end
  # {
  #   "service_sid": "KSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "status": "in-progress",
  #   "unique_name": "unique_name",
  #   "date_started": "2015-07-30T20:00:00Z",
  #   "date_ended": "2015-07-30T20:00:00Z",
  #   "date_last_interaction": "2015-07-30T20:00:00Z",
  #   "date_expiry": "2018-07-31",
  #   "ttl": 3600,
  #   "mode": "message-only",
  #   "closed_reason": "",
  #   "sid": "KCXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "date_updated": "2015-07-30T20:00:00Z",
  #   "date_created": "2015-07-30T20:00:00Z",
  #   "account_sid": "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "url": "https://proxy.twilio.com/v1/Services/KSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Sessions/KCXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "links": {
  #     "interactions": "https://proxy.twilio.com/v1/Services/KSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Sessions/KCXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Interactions",
  #     "participants": "https://proxy.twilio.com/v1/Services/KSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Sessions/KCXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Participants"
  #   }
  # }


  def self.close_proxy_session(session_sid)
    @client.proxy
      .services(Rails.application.credentials.twilio_service_sid)
      .sessions(session_sid)
      .update(status: 'closed')
  end
  # {
  #   "service_sid": "KSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "status": "closed",
  #   "unique_name": "unique_name",
  #   "date_started": "2015-07-30T20:00:00Z",
  #   "date_ended": "2015-07-30T20:00:00Z",
  #   "date_last_interaction": "2015-07-30T20:00:00Z",
  #   "date_expiry": "2018-07-31",
  #   "ttl": 3600,
  #   "mode": "message-only",
  #   "closed_reason": "",
  #   "sid": "KCXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "date_updated": "2015-07-30T20:00:00Z",
  #   "date_created": "2015-07-30T20:00:00Z",
  #   "account_sid": "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "url": "https://proxy.twilio.com/v1/Services/KSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Sessions/KCXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "links": {
  #     "interactions": "https://proxy.twilio.com/v1/Services/KSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Sessions/KCXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Interactions",
  #     "participants": "https://proxy.twilio.com/v1/Services/KSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Sessions/KCXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Participants"
  #   }
  # }

  def self.add_participant(session_sid, user)
    @client.proxy
      .services(Rails.application.credentials.twilio_service_sid)
      .sessions(session_sid)
      .participants
      .create(
        friendly_name: user.email,
        identifier: "+#{user.phone_number[0] == '1' ? user.phone_number : '1' + user.phone_number}"
      )
  end
  # {
  #   "sid": "KPXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "session_sid": "KCXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "service_sid": "KSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "account_sid": "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "identifier": "+15558675310",
  #   "proxy_identifier": "proxy_identifier",
  #   "proxy_identifier_sid": "PNXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "friendly_name": "Alice",
  #   "date_deleted": "2015-07-30T20:00:00Z",
  #   "date_updated": "2015-07-30T20:00:00Z",
  #   "date_created": "2015-07-30T20:00:00Z",
  #   "url": "https://proxy.twilio.com/v1/Services/KSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Sessions/KCXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Participants/KPXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  #   "links": {
  #     "message_interactions": "https://proxy.twilio.com/v1/Services/KSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Sessions/KCXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Participants/KPXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/MessageInteractions"
  #   }
  # }
  
  def self.automated_call(reminder)
    @client.calls.create(
      url: "http://69.174.144.43:3000/api/v1/twilio/twiml?reminder_id=#{reminder.id}",
      to: "+#{reminder.creator.phone_number[0] == '1' ? reminder.creator.phone_number : '1' + reminder.creator.phone_number }",
      from: '+15878415439'
    )
  end

  def self.automated_sms(reminder)
    @client.messages.create(
      from: '+15878415439',
      to: "+#{reminder.creator.phone_number[0] == '1' ? reminder.creator.phone_number : '1' + reminder.creator.phone_number }",
      body: "Don't forget! #{reminder.title}"
    )
  end

  # def self.mask_number(reminder, creator, reminding_user)
  #   session = self.create_proxy_session
  #   reminder.update(proxy_session_sid: session.sid)
  #   self.add_participant(session.sid, creator)
  #   participant = self.add_participant(session.sid, reminding_user)
  #   Delayed::Job.enqueue(
  #     ReminderBackupJob.new(id),
  #     0,
  #     Time.now + 3.minutes + 30.seconds
  #   )
  #   participant.proxy_identifier
  # end

end
