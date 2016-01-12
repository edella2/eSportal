class SubscriptionsController < ApplicationController
  require 'chronic'

  def create
    # subscribe to an event on google calendar
    p "GOT HERE OH YEAH SAYS KOOL AID GUY"
    @event = {
      'summary' => 'New Event Title',
      'description' => 'The description',
      'location' => 'Location',
      'start' => { 'dateTime' => Chronic.parse('tomorrow 4 pm') },
      'end' => { 'dateTime' => Chronic.parse('tomorrow 5pm') } }

    p "*" * 50
    p "@event"
    p @event
    p "*" * 50

    client = Google::APIClient.new
    p "*" * 50
    p "Client"
    p client
    p "*" * 50
    client.authorization.access_token = current_user.token
    p "*" * 50
    p "client.authorization"
    p client.authorization.access_token
    p "*" * 50
    service = client.discovered_api('calendar', 'v3')
    p "*" * 50
    p "service"
    p service
    p "*" * 50

    @set_event = client.execute(api_method: service.events.insert,
                                parameters: { 'calendarId' => 'primary', 'sendNotifications' => true },
                                body: JSON.dump(@event),
                                headers: { 'Content-Type' => 'application/json' })

    p "*" * 50
    p "@set_event"
    p @set_event
    p "*" * 50
    redirect_to '/'
  end

end
