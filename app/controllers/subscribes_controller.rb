class SubscribesController < ApplicationController

	require 'google/api_client'
	require 'google/api_client/client_secrets'
	require 'google/api_client/auth/installed_app'
	require 'google/api_client/auth/storage'
	require 'google/api_client/auth/storages/file_store'
	require 'fileutils'

	APPLICATION_NAME = 'eSportal'
	CLIENT_SECRETS_PATH = 'client_secret.json'
	CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "calendar-ruby-quickstart.json")
	SCOPE = 'https://www.googleapis.com/auth/calendar'


	def authorize
	  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

	  file_store = Google::APIClient::FileStore.new(CREDENTIALS_PATH)
	  storage = Google::APIClient::Storage.new(file_store)
	  p "......................................................................"
	  p auth = storage.authorize
	  p "......................................................................"

	  if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
	    app_info = Google::APIClient::ClientSecrets.load(CLIENT_SECRETS_PATH)
	    flow = Google::APIClient::InstalledAppFlow.new({
	      :client_id => app_info.client_id,
	      :client_secret => app_info.client_secret,
	      :scope => SCOPE})
	    auth = flow.authorize(storage)
	    puts "Credentials saved to #{CREDENTIALS_PATH}" unless auth.nil?
	  end
	  auth
	end


	def create
		@event = {
		  'summary' => 'New Event Title',
		  'description' => 'The description',
		  'location' => 'Location',
		  'start' => { 'dateTime' => '2016-01-11T09:00:00-07:00' },
		  'end' => { 'dateTime' => '2016-01-11T12:00:00-07:00' }
		  }


		client = Google::APIClient.new(:application_name => APPLICATION_NAME)
		client.authorization = authorize
		calendar_api = client.discovered_api('calendar', 'v3')


		results = client.execute!(
  			:api_method => calendar_api.events.insert,
		  	:parameters => {
		    	:calendarId => 'primary',
		    	:body_object => @event
		    })

		@event = results.data
		puts "Event created: #{@event.htmlLink}"
		redirect_to '/'
	end
end
