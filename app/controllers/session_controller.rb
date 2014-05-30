#coding: utf-8
class SessionController < ApplicationController
	def index
		render "index"
	end
	def show
		render "index"
	end
	def create
		@user = User.find_by_name(params[:name])
		if @user && @user.authenticate(params[:pass])
			session[:user_id] = @user.id
			if params[:redirect_pass]
				redirect_to params[:redirect_pass]
			else
				redirect_to :root
			end
		else
			flash.now[:notice] = "ID,パスワードが一致しません"
			render "index"
		end
	end
	def destroy
		session[:user_id] = nil
		redirect_to :root
	end
end
