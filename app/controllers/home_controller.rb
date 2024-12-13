class HomeController < ApplicationController

  layout 'login', only: [:index]

  def index
    if current_user
      redirect_to agreements_path # Redirige al dashboard si el usuario está autenticado
    else
      redirect_to login_path # Redirige al login si el usuario no está autenticado
    end
  end
end
