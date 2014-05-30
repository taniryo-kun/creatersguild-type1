# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#= require scroll_event_mod
#= require works_perolist
#= require ellipsis
$(document).ready ->

  console.log "works.js loaded"
  $(".ellipsis").ellipsis()
  
  height  = $(window).scrollTop()
  #対象オブジェクトが画面上に見えているか否かのフラグ
  visible = true
  workformopen = false
  dropmenu_open = false

  #スクロールの上下を認識して指定要素を操作するメソッド
  openHeader = ->
    console.log "openHeader"
    view = $("#shared_header")
    headerbtn = $("#headerbtn")
    view.animate opacity:'show', 'top':8, 'easing':'swing', 'duration':'3', 'queue':false
    view.animate 'top':0, 'easing':'linear', 'duration':'1'
    headerbtn.css({"display":"none"})

  workformbtn = ->
    console.log 'workformbtn!'
    console.log workformopen
    header = $("#shared_header")
    workform = $("#workform")
    if workformopen == false
      console.log "aaa"
      opn_workform(header,workform)
    else
      cls_workform(header,workform)

  opn_workform = (header,workform) ->
      #ios5以下がアクセスしてきたときはアラードする
      if window.navigator.platform == "iPhone"
        if window.navigator.userAgent.search("Version/5") != -1
          alert "ios 5以下では作品へのコメントのみ可能です。"
      header.animate {'height':'400px'},'slow'
      workform.css {'display':'block'}
      workformopen = true


  cls_workform = (header,workform) ->
      header.animate {'height':'50px'},'slow'
      workform.css {'display':'none'}
      workformopen = false

  # ヘッダーのドロップメニュー開閉用
  openmenu = ->
    console.log "openmenu fired!"
    console.log dropmenu_open
    header = $("#title_box")
    if dropmenu_open == false
      header.animate {'height':'260px'},'slow'
      $("#header_dropmenu").css {'display':'block'}
      dropmenu_open = true
    else
      header.animate {'height':'50px'},'slow'
      $("#header_dropmenu").css {'display':'none'}
      dropmenu_open = false

  $(".want_button")
    .on 'ajax:success', (event, data, status, xhr) ->
        if data.status == true
          $("#want_point").html(data.work.want_point)

  $("#headerbtn").bind("click",openHeader)
  $("#workformbtn").bind("click", workformbtn)
  $("#openmenu_btn").bind("click",openmenu)

  #リスト化処理
  works = $('.work')
  for work, i in works
    if i == 0
    else
      $(work).css(
          "z-index": 9998 - i
      )

  window.pero_list = new PeroList("#slider_frame")
