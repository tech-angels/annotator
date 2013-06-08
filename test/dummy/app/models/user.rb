class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  def self.devise_modules
    [:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable]
  end

end
