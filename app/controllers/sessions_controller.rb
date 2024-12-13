class SessionsController < ApplicationController

  layout 'login', only: [:new]

  def new
  end

  def create
    auth = request.env['omniauth.auth']

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