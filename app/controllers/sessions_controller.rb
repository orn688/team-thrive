class SessionsController < ApplicationController
  def new
    remember_me = params[:session][:remember_me] ? "1" : "0"
    redirect_to "https://www.strava.com/oauth/authorize?" +
    		"client_id=#{Rails.application.secrets.STRAVA_CLIENT_ID}" +
    		"&redirect_uri=#{strava_auth_url}" +
    		"&state=#{remember_me}" +
    		"&response_type=code"
  end

  def create
    if params["error"]
      flash[:warning] = "Strava authentication failed. Make sure you have an " +
                        "activated Strava account and that you are logged in " +
                        "to Strava on this device."
      redirect_to root_url
    end

    @user = User.from_strava(strava_access_info(params["code"]))

    log_in @user
    params["state"] == "1" ? remember(@user) : forget(@user)
    redirect_back_or_to @user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
