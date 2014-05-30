$(document).ready ->
	console.log "howto.js.coffee"
	setTimeout(scrollBy(1,0),1000)

	# setTimeout(slideani,2000)
	windowWidth = $(window).width()
	$(".slide").css({
		width: windowWidth + "px"
		float:"left"
		})
	slidenum = $(".slide").length
	wrapperWidth = windowWidth * slidenum
	$("#slide_wrapper").css({
		width: wrapperWidth
		})

	window.slide_show = new SlideShow()

class SlideShow
	constructor: ->
		$(".next_button").bind("click",slideani)

	slideani= =>
		console.log "slideani!!"
		slideLeft = $(".slide").css("left").replace("px","")
		console.log slideLeft
		slideWidth = slideLeft - $(".slide").width() + "px"
		$('.slide').animate({left:slideWidth},"slow")

window.SlideShow = SlideShow
