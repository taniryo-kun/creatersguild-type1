# coding: utf-8

class IdeasController < ApplicationController
  def index
  	@ideas = Idea.all
    @newidea = Idea.new
  	respond_to do |format|
  		format.html
  	end
  end

  def show
    @idea = Idea.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def create
  	@idea = Idea.new(params[:idea])
  	if @idea.save
  		redirect_to action:"index" , :notice => "アイディア投稿に成功しました。"
  	else
  		redirect_to :root, :notice => "アイディア投稿に失敗しました。"
  	end
  end
end
