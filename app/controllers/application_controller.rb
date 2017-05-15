class ApplicationController < ActionController::Base

  #protect_from_forgery with: :exception

  include AkerAuthenticationGem::AuthController
  include JWTCredentials

  include AkerPermissionControllerConfig
end