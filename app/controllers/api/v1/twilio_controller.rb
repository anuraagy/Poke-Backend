class Api::V1::TwilioController < Api::V1::BaseController
  include TwilioHelper

  def callback
    puts params
    if params[:outboundResourceStatus] == 'completed' and params[:outboundResourceType] == 'call'
      TwilioHelper::close_proxy_session(params[:interactionSessionSid])
    end
    if params[:outboundResourceStatus] == 'delivered' ||
       params[:outboundResourceStatus] == 'initiated' ||
       params[:outboundResourceStatus] == 'completed'
      r = Reminder.find_by(proxy_session_sid: params[:interactionSessionSid])
      r.update(did_proxy_interact: true)
    end
    head :ok
  end

  def twiml
    params.require(:reminder_id)
    resp = Twilio::TwiML::VoiceResponse.new
    resp.pause(length: 1)
    resp.say(voice: "man", message: "Hello, this is an automated reminder from Poke. "\
                                    "Don't forget about your reminder titled, "\
                                    "\"#{Reminder.find(params[:reminder_id]).title}\". Goodbye!"
    )
    resp.pause(length: 3)
    resp.play(url: 'http://demo.twilio.com/docs/classic.mp3')

    response.headers['Content-Type'] = 'application/xml; charset=utf-8'
    render plain: resp.to_s
  end

end
