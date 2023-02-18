class VoiceController < ApplicationController
  skip_before_action :authenticate_user!
  after_action :verify_authorized, except: :trigger_call

  require "vonage"
  require "open-uri"

  def trigger_call
    url = URI.open(ENV.fetch('VONAGE_PRIVATE_KEY_URL')).read
    # file = File.read('private.key')
    client = Vonage::Client.new(
      application_id: "96063012-ae83-424a-9661-caba31c197d6",
      private_key: url
    )

    client.voice.create({
      to: [{
        type: 'phone',
        number: "818068285005"
      }],
      from: {
        type: 'phone',
        number: "12013800657"
      },
      answer_url: [
        'https://nexmo-community.github.io/ncco-examples/first_call_talk.json'
        ]
      }
    )
  end
end
