#coding: utf-8
class WorkstagesController < ApplicationController
	def show
		@work = Work.find(params[:work_id])
		@stage = Workstage.find(params[:id])
    	@comment = Comment.new(:commentable_id => params[:id], :commentable_type => "Workstage")
		@point = Point.new(:workstage_id => params[:id])
		@comments, @has_next = Comment.get_relative(params)
		respond_to do |format|
			format.html
		end
	end

	def new
	  @work = Work.find(params[:work_id])
	  @workstage = Workstage.new(:work_id => params[:work_id], :start_image => Image::StartImage.new())
    render
    #render json: @workstage.work
	end

	def create
		@workstage = Workstage.new(params[:workstage])
		@work = Work.find(params[:work_id])
		if params[:workstage][:stage_num] == "finished"
			@work.update_attribute(:status ,"finished")
		else
			@work.update_attribute(:status, "making")
		end
		@workstage.stage_num = @work.workstages.length + 1
		#トリミング
		#保存前に1280,960にリサイズ
		if @workstage.save
			respond_to do |format|
				format.html {redirect_to [:selectitem,@work,@workstage], notice: "新規作品登録に成功しました。"}
			end
		else
			respond_to do |format|
				format.html {render "new"}
			end
		end
	end

	#工程終了画像登録ページ
	def afterimage
		@workstage = Workstage.find(params[:id])
		@work = Work.find(params[:work_id])
		@workstage.build_after_image
		render "afterimage"
	end

	#材料・ツール・文献選択画面
	def selectitem
		@workstage = Workstage.find(params[:id])
		@work = Work.find(params[:work_id])
		render "selectitem"
	end

	def edit
		@work = Work.find(params[:work_id])
		@workstage = Workstage.find(params[:id])
		render "edit"
	end

	def update
	  	@workstage = Workstage.find(params[:id])
	  	@workstage.update_attributes params[:workstage]
    	@work = Work.find(params[:work_id])
    	if params[:redirectURL]
    		@redirectURL = params[:redirectURL]
    		redirect_to[@work, @workstage, redirectURL: @redirectURL]
    	else
	  		redirect_to [@work, @workstage]
	  	end
	end

	def edit
		@work = Work.find(params[:work_id])
		@workstage = Workstage.find(params[:id])
		respond_to do |format|
			format.html # edit.html.erb
		end
	end
	
	def destroy

	end
end
