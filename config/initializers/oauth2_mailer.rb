require 'signet/oauth_2/client'
require 'json'

CREDENTIALS_PATH = Rails.root.join('config', 'gmail-credentials.json')

def get_access_token
  stored_tokens = JSON.parse(File.read(CREDENTIALS_PATH)) rescue {}

  unless stored_tokens.key?("default")
    raise "❌ No se encontraron credenciales. Genera primero el refresh_token."
  end

  # Revisar si el access_token sigue siendo válido
  if stored_tokens["default"]["expires_at"].to_i > Time.now.to_i
    return stored_tokens["default"]["access_token"]
  end

  # Si el access_token ha expirado, obtener uno nuevo con el refresh_token
  client = Signet::OAuth2::Client.new(
    client_id: ENV['GOOGLE_CLIENT_ID'],
    client_secret: ENV['GOOGLE_CLIENT_SECRET'],
    token_credential_uri: "https://oauth2.googleapis.com/token",
    refresh_token: stored_tokens["default"]["refresh_token"],
    scope: "https://mail.google.com/",
    grant_type: "refresh_token"
  )

  client.refresh!
  new_access_token = client.access_token

  # Guardar el nuevo access_token en el archivo JSON
  stored_tokens["default"]["access_token"] = new_access_token
  stored_tokens["default"]["expires_at"] = Time.now.to_i + 3600  # 1 hora más

  File.open(CREDENTIALS_PATH, 'w') do |file|
    file.write(JSON.pretty_generate(stored_tokens))
  end

  new_access_token
end

def generate_xoauth2_token(email)
  access_token = get_access_token
  auth_string = "user=#{email}\x01auth=Bearer #{access_token}\x01\x01"

  #Base64.strict_encode64(auth_string)

  access_token
end
