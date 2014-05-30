$(document).ready ->	
	$('#slideup').on 'click' ,(e) ->
		works = $('#works')
		sliderframe = $('#slider_frame')
		positiontop = works.position().top
		positiontop -= 326
		works.animate({top:positiontop},500)
		console.log positiontop, sliderframe.position().bottom

	$('#slidedown').on 'click' ,(e) ->
		works = $('#works')
		sliderframe = $('#slider_frame')
		positiontop = works.position().top
		positiontop += 326
		works.animate({top:positiontop},500)
		console.log positiontop, sliderframe.position().bottom
		