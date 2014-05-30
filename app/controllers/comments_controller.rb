class CommentsController < ApplicationController
  def index
    comments, has_next = Comment.get_relative(params)
    
    respond_to do |format|
      format.json {
        render json: {comments: comments, has_next: has_next}
      }
    end
  end

	def create
		@comment = Comment.new(params[:comment])
		#どのworkstageへのコメントか特定
		@comment.commentable_id = params[:workstage_id]
		@comment.commentable_type = "Workstage"
		
		#point情報付きコメントの場合、point_idを付加
		@comment.point_id = params[:point_id] if params[:point_id].present?
		
		#ログインユーザーならuser_idを指定
		@user ||= User.find(session[:user_id]) if session[:user_id]
		if @user
		  @comment.user_id = @user.id
		end
		
		if @comment.save
      respond_to do |format|
        format.json {
          #ページ読み込みからコメント投稿までに投稿されたコメントを取得
          comments, has_next = Comment.get_relative(params, false)
          render json: {status: true, comments: comments}
        }
      end
		else
      respond_to do |format|
        format.json {
          render json: {status:false, data:@comment}
        }
      end
		end
	end

end
