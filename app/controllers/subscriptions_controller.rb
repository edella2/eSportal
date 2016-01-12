class SubscriptionsController < ApplicationController
  require 'chronic'

  def create
    # subscribe to an event on google calendar
    tournament = Tournament.find(favorite_params[:favoritable_id])

    @event = {
      'summary' => tournament.name,
      'description' => tournament.description,
      'location' => tournament.city,
      'start' => { 'dateTime' => DateTime.parse("#{tournament.start_date}") },
      'end' => { 'dateTime' => DateTime.parse("#{tournament.end_date}") } }

    p @event
    p "*"*50

    client = Google::APIClient.new
    p client
    p "*"*50
    client.authorization.access_token = current_user.token
    p client.authorization.access_token
    p "*"*50
    service = client.discovered_api('calendar', 'v3')
    p service
    p "*"*50

    @set_event = client.execute(api_method: service.events.insert,
                                parameters: { 'calendarId' => 'primary', 'sendNotifications' => true },
                                body: JSON.dump(@event),
                                headers: { 'Content-Type' => 'application/json' })
    p @set_event
    p "*"*50
    redirect_to '/'
  end

  private

    def favorite_params
      params.require(:favorite).permit(:favoritable_id, :user_id, :favoritable_type)
    end

end
