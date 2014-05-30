class PointsController < ApplicationController
  def index
    parent = Workstage.find(params[:workstage_id])
    @points = parent.points.find(:all)
    respond_to do |format|
      format.json{
        render json: {status: true, points: @points}
      }
    end
  end
  def create
    #保存すPointデータを作成
    @point = Point.new(params[:point])
    #どのworkstageへのポイントか特定
    @point.workstage_id = params[:workstage_id]

    #保存すCommentデータを作成
    @comment = Comment.new(params[:comment])
    #どのworkstageへのコメントか特定
    @comment.commentable_id = params[:workstage_id]
    @comment.commentable_type = "Workstage"
    #ログインユーザーならuser_idを指定
    @user ||= User.find(session[:user_id]) if session[:user_id]
    if @user
      @comment.user_id = @user.id
    end

    #既ポイント判定処理 ->新規メソッド作成
    if Point.point_existence_chk(@point)
      ActiveRecord::Base.transaction do
        @point.comments << @comment
        @point.save!
        @comment.save!
      end
      comments, has_next = Comment.get_relative(params, false)
      render json: {status: true, point: @point, comments: comments}
    else
      #サーバサイドの既ポイント判定処理ではじかれた場合の処理
      render json: {status: false, data: @point}
    end
  rescue
    render json: {status: false, data: @point, comment: @comment}
  end
end
