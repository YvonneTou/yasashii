class CalendarController < ApplicationController
  before_action :skip_authorization # needs to be updated
  def redirect
    connection_id = params[:connection_id]
    client = Signet::OAuth2::Client.new(client_options(connection_id))
    # authorize client
    redirect_to client.authorization_uri.to_s, allow_other_host: true
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options(params[:state]))
    client.code = params[:code]
    response = client.fetch_access_token!
    session[:authorization] = response
    connect_id = client.state
    new_event(connect_id)
    redirect_to dashboard_url
  end

  def calendars
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists
  end

  def events
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @event_list = service.list_events(params[:calendar_id])
  end

  def new_event(connection_id)
    connection = Connection.find(connection_id.to_i)

    client = Signet::OAuth2::Client.new(client_options(params[:state]))
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    event_list = service.list_calendar_lists.items
    primary_cal = event_list[0]
    primary_cal_id = primary_cal.id

    pri_cal_id = connection.user.email

    # today = Date.today

    event = Google::Apis::CalendarV3::Event.new(
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: '2023-03-5T13:00:00+09:00',
        time_zone: 'Asia/Tokyo'
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: '2023-03-5T14:00:00+09:00',
        time_zone: 'Asia/Tokyo'
      ),
      summary: 'Lunch gathering with my team!!'
    )

    service.insert_event(primary_cal_id, event)
    # service.insert_event(params[:calendar_id], event)

    # redirect_to events_url(calendar_id: params[:calendar_id])
  end

  private

  def client_options(connection_id)
    {
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      # client_id: ENV['google_client_id'],
      # client_secret: ENV['google_client_secret'],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: callback_url,
      state: connection_id
    }
  end
end
