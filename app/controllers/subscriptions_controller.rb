class SubscriptionsController < ApplicationController
  require 'chronic'

  def create
    # subscribe to an event on google calendar
    p "GOT HERE OH YEAH SAYS KOOL AID GUY"
    @event = {
      'summary' => 'New Event Title',
      'description' => 'The description',
      'location' => 'Location',
      'start' => { 'dateTime' => '2016-01-12T09:00:00-07:00' },
      'end' => { 'dateTime' => '2016-01-12T10:00:00-07:00' } }

    client = Google::APIClient.new
    client.authorization.access_token = current_user.token
    service = client.discovered_api('calendar', 'v3')

    @set_event = client.execute(api_method: service.events.insert,
                                parameters: { 'calendarId' => 'primary', 'sendNotifications' => true },
                                body: JSON.dump(@event),
                                headers: { 'Content-Type' => 'application/json' })
    redirect_to '/'
  end

end
