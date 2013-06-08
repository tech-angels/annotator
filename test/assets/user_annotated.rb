# Attributes:
# * id [integer, primary, not null] - primary key
# * authentication_token [string] - Devise Token authenticable module
# * confirmation_sent_at [datetime] - Devise Confirmable module
# * confirmation_token [string] - Devise Confirmable module
# * confirmed_at [datetime] - Devise Confirmable module
# * created_at [datetime, not null] - creation time
# * current_sign_in_at [datetime] - Devise Trackable module
# * current_sign_in_ip [string] - Devise Trackable module
# * description [string, default="Long\nmultil..."] - TODO: document me
# * email [string, default="", not null]
# * encrypted_password [string, default="", not null] - Devise encrypted password
# * failed_attempts [integer, default=0] - Devise Lockable module
# * last_sign_in_at [datetime] - Devise Trackable module
# * last_sign_in_ip [string] - Devise Trackable module
# * locked_at [datetime] - Devise Lockable module
# * password_salt [string] - Devise Encriptable module
# * remember_created_at [datetime] - Devise Rememberable module
# * reset_password_sent_at [datetime] - Devise Recoverable module
# * reset_password_token [string] - Devise Recoverable module
# * sign_in_count [integer, default=0] - Devise Trackable module
# * unconfirmed_email [string] - Devise Confirmable module
# * unlock_token [string] - Devise Locakble module
# * updated_at [datetime, not null] - last update time
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  def self.devise_modules
    [:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable]
  end

end
