
class User < ActiveRecord::Base
  #Can favorite models that are favorable
  has_many :favorites, inverse_of: :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]



	def self.from_omniauth(access_token, signed_in_resource = nil)
	    data = access_token.info
	    user = User.where(:email => data["email"]).first

      if user
        user.provider = access_token.provider
        user.uid = access_token.uid
        user.token = access_token.credentials.token
        user.save
	    else
	      user = User.create(
          name:     data["name"],
       	  email:    data["email"],
      	  password: Devise.friendly_token[0,20],
          uid:      access_token.uid,
          provider: access_token.provider,
          token:    access_token.credentials.token
	      )
	    end
	    user
	end
end
