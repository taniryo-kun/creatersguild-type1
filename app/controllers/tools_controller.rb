#coding: utf-8
class ToolsController < ApplicationController

	def index
	end

	def show
		@tool = Tool.find(params[:id])
		@redirectURL = params[:redirectURL] if params[:redirectURL]
		respond_to do |format|
			format.html # show.html.erb
		end
	end

	def new
		@tool = Tool.new
		respond_to do |format|
			format.html # new.html.erb
			format.xml {render :xml => @book}
		end
	end

	def create
		@tool = Tool.new(params[:tool])
		@redirectURL = params[:redirectURL]
		if @tool.save
			@usrtoolrelation = Usertoolrelation.new(:user_id => current_user.id, :tool_id => @tool.id)
			if @usrtoolrelation.save
				redirect_to(request.referer, notice: "ツール登録が完了しました", redirectURL: @redirectURL )
			else
				redirect_to(request.referer, notice: "ツール・ユーザの紐付けに失敗しました", redirectURL: @redirectURL  )
			end
		else
			redirect_to(request.referer, notice: "ツール登録に失敗しました", redirectURL: @redirectURL  )
		end
	end

	def edit
		@tool = Tool.find(params[:id])
		respond_to do |format|
			format.html # edit.html.erb
		end
	end

	def update
		@tool = Tool.find(params[:id])
		respond_to do |format|
			if @tool.update_attributes(params[:tool])
				format.html {redirect_to(tool_path, notice: "ツール情報を修正しました" )}
				format.xml {head :ok}
			else
				format.html {render action: edit}
				format.xml {render xml: @tool.errors, status: :unprocessable_entry}
			end
		end
	end

	def destroy
		Tool.destroy(params[:id])
		respond_to do |format|
			format.html {redirect_to(controller: 'users', id: current_user.id, action: 'addequipment', notice: "ツール情報を削除しました")}
			format.xml {head :ok}
		end
	end
end