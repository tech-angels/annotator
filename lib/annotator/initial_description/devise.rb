module Annotator
  module InitialDescription

    # Initial descriptions for devise specific columns
    class Devise < Base

      def check
        @model.respond_to?(:devise_modules) && columns.keys.include?(@column.to_sym)
      end

      def columns
        {
          :encrypted_password         => "Devise encrypted password",
          :reset_password_token       => "Devise Recoverable module",
          :reset_password_sent_at     => "Devise Recoverable module",
          :remember_created_at        => "Devise Rememberable module",
          :sign_in_count              => "Devise Trackable module",
          :current_sign_in_at         => "Devise Trackable module",
          :last_sign_in_at            => "Devise Trackable module",
          :current_sign_in_ip         => "Devise Trackable module",
          :last_sign_in_ip            => "Devise Trackable module",
          :password_salt              => "Devise Encriptable module",
          :confirmation_token         => "Devise Confirmable module",
          :confirmed_at               => "Devise Confirmable module",
          :confirmation_sent_at       => "Devise Confirmable module",
          :unconfirmed_email          => "Devise Confirmable module",
          :failed_attempts            => "Devise Lockable module",
          :unlock_token               => "Devise Locakble module",
          :locked_at                  => "Devise Lockable module",
          :authentication_token       => "Devise Token authenticable module"
        }
      end

      def text
        columns[@column.to_sym]
      end

    end
  end
end
