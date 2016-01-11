class SubscribesController < ApplicationController
	require 'google/api_client'
	require 'google/api_client/client_secrets'
	require 'google/api_client/auth/installed_app'
	require 'google/api_client/auth/storage'
	require 'google/api_client/auth/storages/file_store'
	require 'fileutils'

	APPLICATION_NAME = 'esportal-web'
	CLIENT_SECRETS_PATH = 'client_secret.json'
	CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
		"calendar-ruby-quickstart.json")
	SCOPE = 'https://www.googleapis.com/auth/userinfo.email,https://www.googleapis.com/auth/calendar'

	def create
		event = {
		  'summary' => 'Google I/O 2015',
		  'location' => '800 Howard St., San Francisco, CA 94103',
		  'description' => 'A chance to hear more about Google\'s developer products.',
		  'start' => {
		    'dateTime' => '2015-05-28T09:00:00-07:00',
		    'timeZone' => 'America/Los_Angeles',
		  },
		  'end' => {
		    'dateTime' => '2015-05-28T17:00:00-07:00',
		    'timeZone' => 'America/Los_Angeles',
		  },
		  'recurrence' => [
		    'RRULE:FREQ=DAILY;COUNT=2'
		  ],
		  'attendees' => [
		    {'email' => 'lpage@example.com'},
		    {'email' => 'sbrin@example.com'},
		  ],
		  'reminders' => {
		    'useDefault' => false,
		    'overrides' => [
		      {'method' => 'email', 'minutes' => 24 * 60},
		      {'method' => 'popup', 'minutes' => 10},
		    ],
		  },
		}

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization request via InstalledAppFlow.
# If authorization is required, the user's default browser will be launched
# to approve the request.
#
	# @return [Signet::OAuth2::Client] OAuth2 credentials
		def authorize
			FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

			file_store = Google::APIClient::FileStore.new(CREDENTIALS_PATH)
			storage = Google::APIClient::Storage.new(file_store)
			auth = storage.authorize

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

# Initialize the API
		client = Google::APIClient.new(:application_name => APPLICATION_NAME)
		puts "-------------#{client.inspect}"
		p "------------------" 
		client.authorization = authorize
		calendar_api = client.discovered_api('calendar', 'v3')

		#
		results = client.execute!(
		  :api_method => calendar_api.events.insert,
		  :parameters => {
		    :calendarId => 'primary'},
		  :body_object => event)
		event = results.data
		puts "Event created: #{event.htmlLink}"


		# Fetch the next 10 events for the user
		# results = client.execute!(
		# 	:api_method => calendar_api.events.insert,
		# 	:parameters => {
		# 		:calendarId => 'primary',
		# 		:maxResults => 10,
		# 		:singleEvents => true,
		# 		:orderBy => 'startTime',
		# 		:timeMin => Time.now.iso8601 })

		# puts "Upcoming events:"
		# puts "No upcoming events found" if results.data.items.empty?
		# results.data.items.each do |event|
		# 	start = event.start.date || event.start.date_time
		# 	puts "- #{event.summary} (#{start})"
		# end
		redirect_to '/'
	end

	# require 'google/api_client'
	# require 'google/api_client/client_secrets'
	# require 'google/api_client/auth/installed_app'
	# require 'google/api_client/auth/storage'
	# require 'google/api_client/auth/storages/file_store'
	# require 'fileutils'

	# APPLICATION_NAME = 'eSportal'
	# CLIENT_SECRETS_PATH = 'client_secret.json'
	# CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
 #                             "calendar-ruby-quickstart.json")
	# SCOPE = 'https://www.googleapis.com/auth/calendar'



	# def create
	# 	@event = {
	# 	  'summary' => 'New Event Title',
	# 	  'description' => 'The description',
	# 	  'location' => 'Location',
	# 	  'start' => { 'dateTime' => '2016-01-11T09:00:00-07:00' },
	# 	  'end' => { 'dateTime' => '2016-01-11T12:00:00-07:00' }
	# 	  }


	# 	client = Google::APIClient.new(:application_name => APPLICATION_NAME)
	# 	client.authorization = authorize
	# 	calendar_api = client.discovered_api('calendar', 'v3')

	# 		def authorize
	#   FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

	#   file_store = Google::APIClient::FileStore.new(CREDENTIALS_PATH)
	#   storage = Google::APIClient::Storage.new(file_store)
	#   p "......................................................................"
	#   p auth = storage.authorize
	#   p "......................................................................"

	#   if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
	#     app_info = Google::APIClient::ClientSecrets.load(CLIENT_SECRETS_PATH)
	#     flow = Google::APIClient::InstalledAppFlow.new({
	#       :client_id => app_info.client_id,
	#       :client_secret => app_info.client_secret,
	#       :scope => SCOPE})
	#     auth = flow.authorize(storage)
	#     puts "Credentials saved to #{CREDENTIALS_PATH}" unless auth.nil?
	#   end
	#   auth
	# end

	# 	results = client.execute!(
 #  			:api_method => calendar_api.events.insert,
	# 	  	:parameters => {
	# 	    	:calendarId => 'primary',
	# 	    	:body_object => @event
	# 	    })

	# 	@event = results.data
	# 	puts "Event created: #{@event.htmlLink}"
	# 	redirect_to '/'
	# end
end
