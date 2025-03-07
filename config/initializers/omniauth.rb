Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {
    scope: "userinfo.email, userinfo.profile, https://mail.google.com/",

    prompt: "select_account",

    # 🔥🔥🔥esto se usa solo para renovar el refresh_token con notificaciones@cimav.edu.mx
    #prompt: 'consent',  # # 🔥 Obliga a Google a solicitar autorización de nuevo
    #access_type: 'offline', # 🔥 Obligatorio para recibir refresh_token

    image_aspect_ratio: "square",
    image_size: 50,

    include_granted_scopes: 'true'
  }
  OmniAuth.config.allowed_request_methods = [:post, :get]
  OmniAuth.config.silence_get_warning = true
end
