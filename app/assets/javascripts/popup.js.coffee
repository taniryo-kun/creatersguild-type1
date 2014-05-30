class Popup
  constructor: ->
    @popup = $("#popup")
    @popup_wrap = $("#popup_wrap")
    
    #汎用ポップアップ用の要素
    @general_content = $(
      "<div>" +
        "<div class='title'></div>" +
        "<div class='description'></div>" +
        "<div class='button_wrap'>" +
          "<a class='negative_button' href='javascript:void(0);'></a>" +
          "<a class='positive_button' href='javascript:void(0);'></a>" +
        "</div>" +
      "</div>"
    )
      .css(
        display: "none"
      )
      .appendTo(@popup)
    @general_title = @general_content.find(".title")
    @general_description = @general_content.find(".description")
    @general_negative_button = @general_content.find(".negative_button")
      .bind("click", @onNegativeAnswer)
    @general_positive_button = @general_content.find(".positive_button")
      .bind("click", @onPositiveAnswer)
    
    #一時変数用プロパテイ
    @temp = {}
    
  show: () ->
    args = arguments
    if args.length == 0
      @popup_wrap.show()
    else
      @switchContent(args[0])
      @popup_wrap.show()
    
    #スクロールの禁止
    @popup_wrap.on('touchmove.preventScroll', -> event.preventDefault())

    #スクロールの禁止PC用
    #@temp.scrollTop = $(window).scrollTop()
    #$("body")
    #  .addClass("prevent_scroll")
    #  .css(
    #    top: @temp.scrollTop * -1 + "px";
    #  )
    return

  hide: ->
    @popup_wrap.hide()
    
    #スクロールの許可
    @popup_wrap.off('.preventScroll')
    
    #スクロールの許可PC用
    #$("body").removeClass("prevent_scroll")
    #$(window).scrollTop(@temp.scrollTop)
    return
  
  switchContent: (target) ->
    #引数targetで受け取った値に応じてpopupの内容を書き換える。
    #targetはjqueryオブジェクト又はセレクタ文字列で指定。
    @popup.children().each ->
      $this = $(this)
      $this.hide()
    if typeof target == "string"
      @popup.find(target).show()
    else
      target.show()
    return
  
  general: (args) ->
    #汎用ポップアップ
    args_initial = {
      title: "タイトル"
      description: "説明"
      positive_button: true
      negative_button: true
      positive_button_text: "OK"
      negative_button_text: "Cancel"
      onPositiveAnswer: -> return
      onNegativeAnswer: -> return
    }
    
    args = $.extend(args_initial, args)

    @general_title.html(args.title)
    @general_description.html(args.description)
    @general_positive_button.html(args.positive_button_text)
    @general_negative_button.html(args.negative_button_text)
    
    @temp.onPositiveAnswer = args.onPositiveAnswer
    @temp.onNegativeAnswer = args.onNegativeAnswer
    
    @show(@general_content)
    
    
  alert: (args) ->
    return
  
  onNegativeAnswer: =>
    console.log "NegativeAnswer"
    @temp.onNegativeAnswer()
    @hide()

  onPositiveAnswer: =>
    console.log "PositiveAnswer"
    @temp.onPositiveAnswer()
    @hide()

window.Popup = Popup
