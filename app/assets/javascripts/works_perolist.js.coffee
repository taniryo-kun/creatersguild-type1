class PeroList
  constructor: (selector) ->
    @frame = $(selector)
    $(window).bind("scrollend", @judgeFocusWork)
    $(window).bind("scrollstart", @unFocusWork)

    @works = $("#works")
    @workarray = $(".work")
    for work,i in @workarray
      $(work).bind("click", @tapFocusWork)
      worktop = $(work).position().top
      # console.log work
      # console.log i + "-> position:" + worktop
    @i = 0
    @timer = null
    #フォーカスされているパネルがあるか判断するためのフラグ
    @focus_on = false

    @judgeFocusWork()

  # touchStart: =>
  #   #event.preventDefault()
  #   @startY = event.touches[0].screenY

  # touchMove: =>
  #   #event.preventDefault()
  #   move = event.touches

  # touchEnd: =>
  #   #event.preventDefault()
  #   @endY = event.changedTouches[0].screenY
  #   #移動量
  #   diff = @endY - @startY
  #   if diff > 15
  #     @flickdown() if @i > 0
  #   else if diff < -15
  #     @flickup() if @i < @workarray.length - 1
  #   else
  #     console.log "タップ！"

  flickup: =>
    console.log "flickup"
    # #worksボックスをptopまで上昇させる
    ptop = @works.position().top - 102#スライド量
    @works.animate({top:ptop},500)

    #重なっているパネル(@i番目の.work)をどかす動き
    worktop = $(@workarray[@i]).position().top - 100
    $(@workarray[@i]).animate({top:worktop},400)

    #カウントアップ
    @i += 1

  flickdown: =>
    console.log "flickdown"
    #カウントダウン
    @i -= 1

    # #worksボックスをptopまで下降させる
    ptop = @works.position().top + 102#スライド量
    @works.animate({top:ptop},500)

    #フォーカス対象をフォーカス位置に合わせる動き
    worktop = $(@workarray[@i]).position().top + 100
    $(@workarray[@i]).animate({top:worktop},500)

  closeHeader: ->
    console.log "closeHeader"
    view = $("#shared_header")
    headerbtn = $("#headerbtn")
    view.animate opacity:'hide', 'top':'-30px', 'easing':'swing', 'duration':'3', 'queue':false
    headerbtn.css({"display":"block"})
  
  judgeFocusWork: =>
    console.log "scroll event fired!"
    #判定エリア設定
    min_focus_y = $(window).scrollTop() + 54
    max_focus_y = min_focus_y + 100
    #判定エリアに入っているworkを抽出
    for work, i in @workarray
      if min_focus_y < $(work).offset().top < max_focus_y
        @focusWork(work)
    return

  tapFocusWork: (event) =>
    @unFocusWork()
    console.log "tapFocusWork!!"
    work = event.currentTarget 
    @focusWork(work)
    return

  focusWork: (work)=>
    console.log "focusWork!"
    console.log @works.position().top
    @focused_work = work
    @zindex = $(work).css("z-index") 
    # console.log @zindex
    dest = $(work).offset().top - 54
    # console.log "scroll to: ", dest
    #位置補正がカクン。アニメーションにしたい。
    $('html,body').animate({scrollTop: dest}, "slow")
    #対象のworkに乗っかっているパネルをどかす
    #もしくは対象workを最前面に出すという方法もあるが自然でない
    # console.log @focused_work
    $(@focused_work).css({
        # "background-color":"red"
        "z-index":9998
      })
    # until pre_panel_num < 0
    #   ptop = $(@workarray[pre_panel_num]).position().top - 100
    #   $(@workarray[pre_panel_num]).animate({top: ptop},500)
    #   pre_panel_num -= 1

    @focus_on = true
    #スクロール後必ず画面が動くため、更新ボタンとか検索窓とか押しにくい
    @pre_scroll_top = $(window).scrollTop()
    @closeHeader()
    return

  unFocusWork: =>
    # 退いたパネルをスクロール時には元の位置にもどしたい（リスト状態でのスクロール）
    #このイベントが発火するとスクロールがキャンセルさせれる
    console.log "unFocusWork() is moving"
    if @focus_on == true
      console.log "unfocus!!"
      $(@focused_work).css({
          "background-color":""
          "z-index": @zindex
      })

      # pre_panel_num = @focus_id - 1
      # until pre_panel_num < 0
      #   ptop = $(@workarray[pre_panel_num]).position().top + 100
      #   $(@workarray[pre_panel_num]).animate({top: ptop},500)
      #   pre_panel_num -= 1
      @focus_on = false

    return

window.PeroList = PeroList
