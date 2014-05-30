#coding:utf-8
class UsersController < ApplicationController
	def index
		
	end

	def show
		@user = User.find(params[:id])
		respond_to do |format|
			format.html
		end
	end

	def new
		@user = User.new(:cpoint => 0, :usericon => Image::Usericon.new())
		respond_to do |format|
			format.html #users/new.html.erb
		end
	end

	def edit
		@user = User.find(params[:id])
		respond_to do |format|
			format.html {render "new"}
		end
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			session[:user_id] = @user.id
			redirect_to :root, notice: "ユーザ登録が完了しました。"
		else
			render "new"
		end
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			redirect_to @user, notice: "ユーザ情報を更新しました。"
		else
			render "new"
		end
	end

	def destroy
		
	end

	def addequipment
		@user = User.find(params[:id])
		@tool = Tool.new(:tool_image => Image::ToolImage.new(), :category => "none")
		@knowledge = Knowledge.new(:knowledge_image => Image::KnowledgeImage.new(), :category => "none")
		@owntools = @user.tools
		@ownknowledges = @user.knowledges
		if params[:redirectURL]
			@redirectURL = params[:redirectURL]
		else
			@redirectURL = request.env["HTTP_REFERER"]
		end
		respond_to do |format|
			format.html {render "addequipment"}
		end
	end
end
