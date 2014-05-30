# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#= require trim_image
#= require ellipsis

$(document).ready ->
  console.log "users.js loaded"
  $(".workpanel_work_wrapper").each ->
    $list = $(this)
    $img = $list.children("div.workpanel_work_image:first")
    $text_box = $list.children("div.workpanel_work_title:first")
    $pr = $text_box.children(".pr:first")
    $pr.height("0px")
    h = $text_box.height() + 10
    $pr.height(Math.round($img.width() * 3 / 4) - h)
  
  $(".ellipsis").ellipsis()
  
	if $("#user_usericon_attributes_image").length != 0
    	window.trimmer = new TrimImage("#user_usericon_attributes_image", 1)

    if $("#tool_tool_image_attributes_image").length != 0
    	window.trimmer = new TrimImage("#tool_tool_image_attributes_image", 1)

    if $("#knowledge_knowledge_image_attributes_image").length != 0
    	window.trimmer = new TrimImage("#knowledge_knowledge_image_attributes_image", 1)