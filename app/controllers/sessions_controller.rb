class SessionsController < ApplicationController

  layout 'login', only: [:new]

  def new
  end

  def create
    auth = request.env['omniauth.auth']

=begin
    # Extract OAuth Tokens
    # Activarlo para generar refresh_token con notificaciones@cimav.edu.mx
    # y en omniauth.rb activar prompt: 'consent' y access_type: 'offline'
    # me a crear config/gmail-credentials.json con las credenciales para el usuario default.
    # el refresh_token es usado para re-generar un access_token para notifiaciones@cimav.edu.mx
    credentials = {
      "access_token"  => auth.credentials.token,
      "refresh_token" => auth.credentials.refresh_token,  # Needed for future email sending
      "expires_at"    => auth.credentials.expires_at,
      "email"         => auth.info.email
    }
    # Ensure we have a refresh token
    if credentials["refresh_token"].nil?
      flash[:alert] = "Google did not provide a refresh token. Try logging out and logging in again."
      redirect_to root_path and return
    end
    # Save credentials to YAML file
    #File.open(Rails.root.join('config', 'gmail-credentials.yaml'), 'w') do |file|
    #  file.write(credentials.to_yaml)
    #end
    #File.open(Rails.root.join('config', 'gmail-credentials.json'), 'w') do |file|
    File.open(Rails.root.join('config', 'atencion_posgrado_credentials.json'), 'w') do |file|
      file.write(credentials.to_json)
    end
=end

    # Validación del dominio
    unless auth.info.email.ends_with?('@cimav.edu.mx')
      flash[:alert] = "Solo los usuarios con correos de 'cimav.edu.mx' pueden iniciar sesión."
      redirect_to root_path and return
    end

    # Si el dominio es correcto, continúa con la autenticación
    user = User.from_omniauth(auth)
    if user
      session[:user_id] = user.id
      redirect_to root_path, notice: "Bienvenido, #{user.nombre}!" # dashboard_path
    else
      redirect_to root_path, alert: "No se pudo iniciar sesión."
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed out!'
  end
end