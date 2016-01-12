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
