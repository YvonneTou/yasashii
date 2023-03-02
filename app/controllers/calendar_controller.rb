class CalendarController < ApplicationController
  before_action :skip_authorization # needs to be updated

  def redirect
    @client = Signet::OAuth2::Client.new(client_options)
    # authorize @client
    redirect_to @client.authorization_uri.to_s, allow_other_host: true
  end

  private

  def client_options
    {
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: callback_url
    }
  end
end
