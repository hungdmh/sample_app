class ApplicationController < ActionController::Base
  include SessionsHelper
  around_action :switch_locale

  def switch_locale &action
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.edit.unauthenticated"
    redirect_to login_url
  end
end
