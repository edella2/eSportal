class SubscriptionsController < ApplicationController
  require 'chronic'

  def create
    # subscribe to an event on google calendar
    tournament = Tournament.find(favorite_params[:favoritable_id])

    @event = {
      'summary' => tournament.name,
      'description' => tournament.description,
      'location' => tournament.city,
      'start' => { 'dateTime' => tournament.start_date },
      'end' => { 'dateTime' => tournament.end_date } }

    client = Google::APIClient.new
    client.authorization.access_token = current_user.token
    service = client.discovered_api('calendar', 'v3')

    @set_event = client.execute(api_method: service.events.insert,
                                parameters: { 'calendarId' => 'primary', 'sendNotifications' => true },
                                body: JSON.dump(@event),
                                headers: { 'Content-Type' => 'application/json' })

    redirect_to '/'
  end

  private

    def favorite_params
      params.require(:favorite).permit(:favoritable_id, :user_id, :favoritable_type)
    end

end
