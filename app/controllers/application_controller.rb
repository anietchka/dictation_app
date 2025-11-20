class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :set_locale
  before_action :authenticate_user!, except: [ :index ]

  def index
    if current_user
      redirect_to dictations_path
    else
      render "sessions/new", layout: "application"
    end
  end

  private

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def authenticate_user!
    redirect_to new_session_path, alert: t("sessions.require_login") unless current_user
  end
end
