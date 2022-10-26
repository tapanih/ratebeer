class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user&.closed
      redirect_to signin_path, notice: "Your account is closed"
      return
    end
    if user&.authenticate(params[:password])
      mitigate_session_fixation
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    else
      redirect_to signin_path, notice: "Username and password do not match"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

  def mitigate_session_fixation
    old_values = session.to_hash
    reset_session
    session.update old_values.except('session_id')
  end
end
