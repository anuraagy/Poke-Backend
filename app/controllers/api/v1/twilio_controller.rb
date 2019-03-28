class Api::V1::TwilioController < Api::V1::BaseController
  include TwilioHelper

  def callback
    puts params
    if params[:outboundResourceStatus] == 'completed' and params[:outboundResourceType] == 'call'
      TwilioHelper::close_proxy_session(params[:interactionSessionSid])
    end
    if params[:outboundResourceStatus] == 'delivered' ||
       params[:outboundResourceStatus] == 'completed'
      r = Reminder.find_by(proxy_session_sid: params[:interactionSessionSid])
      r.update(did_proxy_interact: true)
    end
    head :ok
  end

  def access_token
    type = twilio_params[:type]
    token = nil

    if type == 'chat' 
      token =  TwilioHelper::chat_token(params[:identity])
    else 
      token =  TwilioHelper::voice_token(params[:identity])
    end

    puts "Token: #{token}"

    render status: 200, body: token
  end

  def make_call
    response = Twilio::TwiML::VoiceResponse.new

    response.dial(callerId: params["to"])

    puts response
    render status: 200, body: response
  end

  def place_call
    render status: 200
  end

  def twilio_params
    params.permit(:type)
  end

end
