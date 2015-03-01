class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end
  
  def create_oauth
	nick = env["omniauth.auth"].info.nickname
	user = User.find_by username: nick
	if not user
		user = User.create!(username: nick, github:true, password_digest: 0)
	end
	if not user.github?
		redirect_to :back, notice: "Username #{nick} has alredy been taken"
		return
	end
	if user && !user.banned?
		session[:user_id] = user.id
		redirect_to user_path(user), notice: "Welcome back!"
	end
  end

  def create
      user = User.find_by username: params[:username]
      if user && user.authenticate(params[:password]) && !user.banned?
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
