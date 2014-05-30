# coding: utf-8
class WorkmaterialsController < ApplicationController
	def new
		@work = Work.find(params[:work_id])
		@wkmate = Workmaterial.new
		@redirectURL = params[:redirectURL]
		respond_to do |format|
			format.html # new.html.erb
		end
	end

	def create
		@work = Work.find(params[:work_id])
		@wkmate = Workmaterial.new(params[:workmaterial])
		@redirectURL = params[:redirectURL]
		if @wkmate.save
			redirect_to(request.referer, notice: "材料登録が完了しました")
		else
			redirect_to(request.referer, notice: "材料登録に失敗しました")
		end
	end

	def edit
		@work = Work.find(params[:work_id])
		@wkmate = Workmaterial.find(params[:id])
		@redirectURL = params[:redirectURL]
		respond_to do |format|
			format.html # edit.html.erb
		end
	end

	def update
		@wkmate = Workmaterial.find(params[:id])
		@redirectURL = params[:redirectURL]
		respond_to do |format|
			if @wkmate.update_attributes(params[:workmaterial])
				format.html {redirect_to(work_workmaterial_path, notice: "材料情報を修正しました")}
				format.xml {head :ok}
			else
				format.html {render action: 'edit'}
				format.xml {render xml: @tool.errors, status: :unprocessable_entry}
			end
		end
	end

	def destroy
		Workmaterial.destroy(params[:id])
		@work = Work.find(params[:work_id])
		respond_to do |format|
			format.html {redirect_to(controller: 'works', id: @work.id, action: 'show', notice: '材料情報を削除しました')}
			format.xml {head :ok}
		end
	end

	def show
		@work = Work.find(params[:work_id])
		@wkmate = Workmaterial.find(params[:id])
		@redirectURL = params[:redirectURL]
		respond_to do |format|
			format.html 
		end
	end
end
