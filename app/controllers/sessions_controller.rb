class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
      user = User.find_by username: params[:username]
      if user && user.authenticate(params[:password]) && !user.banned
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      elsif user && user.banned
		redirect_to :back, notice: "Your account is frozen, please contact admin"
      else
        redirect_to :back, notice: "Username and/or password mismatch"
      end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
