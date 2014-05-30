class Comment < ActiveRecord::Base
  attr_accessible :comment, :point_id, :commentable_id, :commentable_type, :comment_status, :user_id
  belongs_to :commentable, :polymorphic => true
  belongs_to :point
  belongs_to :user
  
  scope :newer, order("created_at DESC")

  validates :comment,
    :presence => {:message =>"is need Item"},
    :length => {:maximum => 140, :too_long => 'Message_is_too_long'}
  
  def html
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    class << view
      include ApplicationHelper
      include Rails.application.routes.url_helpers
    end
    html = view.render(:partial => 'shared/comment', :object => self, :formats => [:html])
    return html
  end
  
  #コメント取得用メソッド
  def self.get_relative(params={}, limitation=true)
    #parentを決める
    #pointscontrollerからも呼ばれる場合があるためparams[:controller] == "points"追加 20130317
    if params[:controller] == "comments" || params[:controller] == "points"
      if params[:workstage_id]
        parent = Workstage.find(params[:workstage_id])
      end
      if params[:point_id]
        parent = Point.find(params[:point_id])
      end
    else
      parent = Workstage.find(params[:id])
    end
    
    limit = 10
    
    conditions = []
    if params[:older_than]
      conditions = ["created_at >= ? and created_at <= ?", 1000.year.ago, params[:older_than].to_time()]
    elsif params[:newer_than]
      conditions = ["created_at > ? and created_at <= ?", params[:newer_than].to_time() + 1.seconds, Time.now]
    end

    if limitation
      comments = parent.comments.newer.limit(limit + 1).find(:all, :conditions => conditions)
      if comments.length == limit + 1 then
        has_next = true
      else
        has_next = false
      end
      comments = comments[0,limit]
    else
      comments = parent.comments.newer.find(:all, :conditions => conditions)
    end

    return comments, has_next
  end

  def self.wildcomments(work,nora)
    work.workstages.each do |ws|
      @crecom = ws.comments.select{|com| com.user_id.to_i == work.user_id.to_i }
        binding.pry
        @crecom.each do |creatorscom|
          creatorscom.update_attributes(:user_id => nora.id)
        end
    end
  end
  
  def as_json options = {}
    super :include => [:user], :methods => [:html]
  end
end
