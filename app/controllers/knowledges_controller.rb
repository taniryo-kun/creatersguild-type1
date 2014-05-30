#coding: utf-8
class KnowledgesController < ApplicationController
	def index

	end

	def show
		@knowledge = Knowledge.find(params[:id])
		@redirectURL = params[:redirectURL] if params[:redirectURL]
		respond_to do |format|
			format.html # show.html.erb
		end
	end

	def new
		@knowledge = Knowledge.new
	end

	def create
		@knowledge = Knowledge.new(params[:knowledge])
		@redirectURL = params[:redirectURL]
		if @knowledge.save
			@usrknowledgerelation = Userknowledgerelation.new(:user_id => current_user.id, :knowledge_id => @knowledge.id)
			if @usrknowledgerelation.save
				redirect_to(request.referer, notice: "参考文献登録が完了しました", redirectURL: @redirectURL )
			else
				redirect_to(request.referer, notice: "参考文献・ユーザの紐付けに失敗しました", redirectURL: @redirectURL )
			end
		else
			redirect_to(request.referer, notice: "参考文献登録に失敗しました", redirectURL: @redirectURL )
		end
	end

	def edit
		@knowledge = Knowledge.find(params[:id])
		@redirectURL = params[:redirectURL]
		respond_to do |format|
			format.html # edit.html.erb
		end
	end

	def update
		@knowledge = Knowledge.find(params[:id])
		@redirectURL = params[:redirectURL]
		respond_to do |format|
			if @knowledge.update_attributes(params[:knowledge])
				format.html {redirect_to(knowledge_path, notice: "参考文献情報を修正しました", redirectURL: @redirectURL )}
				format.xml {head :ok}
			else
				format.html {render action: edit}
				format.xml {render xml: @knowledge.errors, status: :unprocessable_entry, redirectURL: @redirectURL}
			end
		end
	end

	def destroy
		Knowledge.destroy(params[:id])
		@redirectURL = params[:redirectURL]
		respond_to do |format|
			format.html {redirect_to(controller: 'users', id: current_user.id, action: 'addequipment', notice: "参考文献情報を削除しました", redirectURL: @redirectURL )}
			format.xml {head :ok}
		end
	end
end