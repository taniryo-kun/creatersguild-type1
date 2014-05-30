# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#= require flickscroll

class FlickSencer
  
  min_move_X = 50
  min_move_Y = 50
  @base = $("#base")

  @base.bind("touchstart", touchHandler, false)
  @base.bind("touchmove", touchHandler, false
  @base.bind("touchend", touchHandler, false)

  touchHandler: (event) ->
    #画面タッチを認識するハンドラ
    event.preventDefault()
    touch = event.touches[0]
    switch event 
      when "touchstart"
        alert "タッチされました(確認アラート)"
        startX = touch.pageX
        startY = touch.pageY
      when "touchmove"
        diffX = touch.pageX - startX
        diffY = touch.pageY - startY
      else
        if Math.abs(diffX) >= min_move_X
          if diffX > 0
            alert "左に動いています（確認アラート）"
          else
            alert "右に動いています（確認アラート）"
        else if Math.abs(diffY) >= min_move_Y
          if diffY > 0
              alert "下に動いています（確認アラート）"
            else
              alert "上に動いています（確認アラート）"
  return
return








