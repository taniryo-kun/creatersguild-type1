# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#= require trim_image

$(document).ready ->
	if $("#knowledge_knowledge_image_attributes_image").length != 0
    	window.trimmer = new TrimImage("#knowledge_knowledge_image_attributes_image", 1)