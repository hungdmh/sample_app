module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    if user_id = session[:user_id]
      User.find_by id: user_id
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by id: user_id
      if user&.authenticated? :remember, cookies[:remember_token]
        log_in user
        user
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def log_out
    forget current_user
    session.delete :user_id
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = {value: user.id, httponly: true}
    cookies.permanent[:remember_token] = {
      value: user.remember_token,
      httponly: true
    }
  end

  def current_user? user
    user&.eql? current_user
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete :forwarding_url
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
