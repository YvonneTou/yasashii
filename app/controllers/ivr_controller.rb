class IvrController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  after_action :verify_authorized, except: [:answer, :event]

  BASE_URL = 'https://452d-124-219-136-119.jp.ngrok.io'

  def answer
    render json:
      [
        {
          action: 'talk',
          text: 'Welcome! This is the Vonage Ruby on Rails IVR Demo Application. Please enter a number on your keypad, followed by the hash key.',
          language: "en-US",
          style: 9
        },
        {
          action: 'input',
          submitOnHash: true,
          eventUrl: ["#{BASE_URL}/event"]
        }
      ].to_json
  end

  def event
    number = params['dtmf']

    render json:
    [
      {
        action: 'talk',
        text: "You entered #{number}. Thank you for trying the Vonage Ruby on Rails IVR Demo Application!",
        language: "en-US",
        style: 9
      }
    ].to_json
  end

end
