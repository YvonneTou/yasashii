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
    # connection = Connection.find(connection_id.to_i)
    # clinic = connection.clinic
    event_details = event_details(connection_id)

    client = Signet::OAuth2::Client.new(client_options(params[:state]))
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    event_list = service.list_calendar_lists.items
    owner_cal = event_list.select { |cal| cal.access_role == "owner" }
    calendar_id = owner_cal[0].id

    # today = Date.today

    event = Google::Apis::CalendarV3::Event.new(
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: event_details[:start_time],
        time_zone: 'Asia/Tokyo'
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: event_details[:end_time],
        time_zone: 'Asia/Tokyo'
      ),
      summary: event_details[:title],
      description: event_details[:description],
    )

    service.insert_event(calendar_id, event)
    # service.insert_event(params[:calendar_id], event)

    # redirect_to events_url(calendar_id: params[:calendar_id])
  end

  private

  def client_options(connection_id)
    {
      # client_id: Rails.application.secrets.google_client_id,
      # client_secret: Rails.application.secrets.google_client_secret,
      client_id: ENV['google_client_id'],
      client_secret: ENV['google_client_secret'],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: callback_url,
      state: connection_id
    }
  end

  def event_details(connection_id)
    connection = Connection.find(connection_id.to_i)
    clinic = connection.clinic
    symptoms = connection.symptoms.join(",")
    info = connection.info.nil? ? 'nil' : connection.info

    {
      title: "Appointment with #{clinic.name}",
      location: clinic.location,
      start_time: connection.appt_date.iso8601,
      end_time: (connection.appt_date + 1.hours).iso8601,
      description: "My symptoms: #{symptoms} \nAddtional info: #{info}\nEvent created by Yasashii.Care"
    }
  end
end
