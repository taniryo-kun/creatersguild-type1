# coding: utf-8

class WorksController < ApplicationController

	#Top(index)ページ表示メソッド
	def index
		#なんでステータスがmakingの作品しか表示しないんだっけ？
		#@works = Work.find(:all,:conditions => {:status => "making"})
		@works = Work.find(:all)
		@idea = Idea.new
		#params[:search]に値が入ってる場合は検索（絞り込み）
		if params[:search]
			@works = Work.search(params[:search])
		end
		# カテゴリリンクが踏まれた場合は:catに値が入った状態でindexメソッドが実行される
		# :catに値が入ってる場合はカテゴリで絞り込み
		if params[:cat]
			@category = Category.find_by_category_name(params[:cat])
			@works = Work.where('category_id = ?',@category.id).all
		end
		# 新規作品の登録
		# ログイン者が作品のクリエータとして登録される
		@work = Work.new(:start_date => Time.now,:status => "register")
		#作品登録時のプルダウン用
		@categories = Category.all
		respond_to do |format|
			format.html #index.html
			format.json {render json: @works}
			format.xml {render xml: @newwork}
		end
	end

	#詳細(show)ページ表示メソッド
	def show
		@work = Work.find(params[:id], :include => :workstages)
		# 材料表示用
		@wkmaterials = Workmaterial.find_all_by_work_id(@work.id)
		# 材料登録用の箱
		@wkmaterial = Workmaterial.new(:work_id => @work.id)
		# 工程表示用
		@ws = Workstage.find_all_by_work_id(@work.id)
		# ツール表示用
		#@tools = Tool.find(@work.id)
		# ツール登録用の箱
		@tool = Tool.new
		respond_to do |format|
			format.html #show.html.erb
			format.xml{render xml: @work}
			format.json{render json: @work}
		end
	end

	def edit
		@work = Work.find(params[:id])
		@categories = Category.all
		respond_to do |format|
			format.html {render "edit"}
		end
	end

	def create
		#formから受け取ったパラメータをworkオブジェクトにぶち込む
		@work = Work.new(params[:work])
		#新しいカテゴリが入力された場合
		@work.category_id = Work.setcat(params[:newcategory]) if params[:newcategory].present?
		if @work.save
			if @idea = params[:work][:idea_id]
				IdeaWorkRelation.create(idea_id: @idea, work_id: @work.id)
			end
				respond_to do |format|
					#format.html {redirect_to :new_work,:flash =>{:data => @work.id}}
	        	format.html {redirect_to new_work_workstage_url([@work])}
			end
		else
			#redirect_to(:root,notice: "新規作品登録に失敗しました。")
			@works = Work.all
			@categories = Category.all
			respond_to do |format|
				format.html {render "index"}
			end
		end
	end

	def new
		@work = Work.new(:title => params[:data][:idea],:start_date => Time.now,:status => "register")
		@idea = Idea.find(params[:data][:idea_id])
		@categories = Category.all
		respond_to do |format|
			format.html 
		end
	end

	def update
		@work = Work.find(params[:id])
		if @work.update_attributes(params[:work])
			redirect_to @work, notice: "作品情報を更新しました。"
		else
			redirect_to :root, notice: "作品情報の更新に失敗しました。"
		end
	end

	def destroy
		
	end

	def wildwork
		@work = Work.find(params[:id])
		@nora = User.find_by_name("nora")
		#work配下を野良化
		Comment.wildcomments(@work,@nora)
		@work.user = @nora
		if @work.save!
			redirect_to :root
		else
			redirect_to "Error!!!"
		end
	end

	def add_want_point
		@work = Work.find(params[:id])
		# もし値がnilなら初期化
		@work.want_point ||= 0
		# 欲しいポイントを一点加算
		@work.want_point += 1
		@work.update_attribute(:want_point, @work.want_point)

		respond_to do |format|
			format.json {
				render json: { status: true, work:@work } 
			}
		end
	end

	#検索用メソッド
	def searchwork
		#searchメソッドをworkモデルに記述
		@works = Work.serch(params[:search])
		@work = Work.new(:start_date => Time.now,:status => "making")
		@users = User.all
		respond_to do |format|
			format.html #index.html
			format.json {render json: @works}
			format.xml {render xml: @newwork}
		end
	end
end
