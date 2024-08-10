class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.full_name
      user.avatar_url = auth.info.image
  end

  user.update(
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      token_expires_at: Time.at(auth.credentials.expires_at)
    )

    user
  end

  def google_oauth_token
    if token_expires_at < Time.now
      refresh_token!
    else
      token
    end
  end

  def refresh_token!
    client = OAuth2::Client.new(Rails.application.credentials.dig(:google_oauth_client_id), Rails.application.credentials.dig(:google_oauth_client_secret), site: 'https://accounts.google.com')
    token = OAuth2::AccessToken.from_hash(client, refresh_token: refresh_token)
    new_token = token.refresh!

    update(
      token: new_token.token,
      token_expires_at: Time.at(new_token.expires_at)
    )

    new_token.token
  end
end
