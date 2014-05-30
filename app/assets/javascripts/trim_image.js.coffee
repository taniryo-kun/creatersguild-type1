class TrimImage
  constructor: (file_input_selector, aspect_ratio)->
    #各種値格納用のプロパティ
    @prop = {
      aspect_ratio: aspect_ratio
      fr: null
    }
    #一時的に確保が必要な変数の箱
    @temp = {
      
    }
    #見かけ上のトリム位置
    @trim = {
      left: 0,
      top: 0,
      width: 0,
      height: 0
    }
    #ベース
    @base = $("#trimmer")
      .css(
        position: "relative",
        overflow: "hidden"
      )
    #ファイルを指定するインプット要素
    @input = $(file_input_selector)
    #フォーム
    @form = @input.closest("form");
    #トリムするの画像が入る場所
    @trim_image = $("<div>").appendTo(@base)
    #プレビュー画像が入る箱
    @preview = $("#preview")
    #プレビュー画像
    @image = null
    
    @guide_base = $("<div id='guide_base'>")
      .css(
        width: "100%",
        height: "100%",
        position: "absolute",
        top: "0px",
        left: "0px",
        display: "none"
      )
      .appendTo(@base)
    @trim_rect = $("<div id='trim_rect'>")
      .css(
        position: "absolute",
      )
      .appendTo(@guide_base)

    #切り取られてなくなるエリア
    @guide_bg = {}
    @guide_bg.left = $("<div>")
      .css(
        position: "absolute",
        left: "0px",
        top: "0px",
        height: "100%",
        background: "#000",
        opacity: 0.75
      )
      .appendTo(@guide_base)
    @guide_bg.right = $("<div>")
      .css(
        position: "absolute",
        right: "0px",
        top: "0px",
        height: "100%",
        background: "#000",
        opacity: 0.75
      )
      .appendTo(@guide_base)
    @guide_bg.top = $("<div>")
      .css(
        position: "absolute",
        top: "0px",
        background: "#000",
        opacity: 0.75
      )
      .appendTo(@guide_base)
    @guide_bg.bottom = $("<div>")
      .css(
        position: "absolute",
        bottom: "0px",
        background: "#000",
        opacity: 0.75
      )
      .appendTo(@guide_base)
    
    #リサイズ用のつまみ
    @resize_knob = $("<div>")
      .css(
        position: "absolute",
        right: "0px",
        bottom: "0px",
        width: "50px",
        height: "50px",
        background: "#f00",
        opacity: 0.5
      )
      .appendTo(@trim_rect)

    #トリム位置のleft, top, width, heightをモデルのアトリビュートとしてポストするためのhiddenフォーム要素を追加
    @trim_input = {}
    model_name = @input.attr("name").replace("[image]", "")
    attr_list = ["left", "top", "width", "height"]
    for attr in attr_list
      @trim_input[attr] = $("<input>")
        .attr(
          type: "hidden",
          name: model_name + "[" + attr + "]",
          value: ""
        )
        .insertBefore(@input)

    #選択ファイルが変更された時のイベント
    @input.bind("change", @onSelect)
    
    #トリミング位置移動に関するイベント
    @trim_rect.bind("touchstart", @onTouchStartTrimRect)
    @trim_rect.bind("touchmove", @onTouchMoveTrimRect)
    @trim_rect.bind("touchend", @onTouchEndTrimRect)

    #トリミングエリアサイズ変更に関するイベント
    @resize_knob.bind("touchstart", @onTouchStartResizeKnob)
    @resize_knob.bind("touchmove", @onTouchMoveResizeKnob)
    @resize_knob.bind("touchend", @onTouchEndResizeKnob)
    
    #submit時に発生するイベント
    @form.bind("submit", @onSubmit)
    
    $("#start_trim_edit_button").on "click", @startEdit
    $("#trim_edit_cancel").on "click", @cancelEdit
    $("#trim_edit_finish").on "click", @finishEdit


  onSelect: =>
    console.log "TrimImage.onSelect プレビューの再描画"
    @trim_image.empty()
    if @input[0].files.length == 0
      console.log "no image"
      return
    else
      file = @input[0].files[0]
      #選択されたファイルが画像ではない場合はリターン
      return if !/^image\/(png|jpeg|gif)$/.test(file.type)
      fr = new FileReader()
      
      fr.onload = =>
        image = new Image()
        image.src = fr.result
        orientation = getOrientation(fr.result)
        image.onload = =>
          @image = $(image)
            .css(width: 100 + "%")
            .appendTo(@trim_image)
          if orientation != 1 and image.width / image.height == @image.width() / @image.height()
            console.log "Exifタグの回転情報と表示に矛盾が生じています。"
            tx = ((image.height - image.width) / 2) / image.width * 100 + "%"
            ty = ((image.width - image.height) / 2) / image.height * 100 + "%"
            if orientation == 6
              deg = "90deg"
            else if orientation == 9
              deg = "-90deg"
            @image.css
              transform: "translate(" + tx + ", " + ty + ") rotateZ(" + deg + ")"
            @prop.prop_for_width = "height"
          else
            @prop.prop_for_width = "height"
          console.log image.width, image.height, @image.width(), @image.height()
          @prop.image = @image
        return
        
      fr.readAsDataURL(file)
      @prop.fr = fr
    return

  initGuide: ->
    console.log "TrimImage.initGuide トリム位置の初期化の動作開始"
    @guide_base
      .css(
        display: "block",
        width: @base.width() + "px",
        height: @base.height() - 5 + "px"
      )
    console.log @trim.width
    if @trim.left == 0 && @trim.top == 0 && @trim.width == 0 && @trim.height == 0
      if @prop.aspect_ratio <= @image.width() / @image.height()
        @trim.height = @image.height()
        @trim.width = @trim.height * @prop.aspect_ratio
        @trim.left = (@image.width() - @trim.width) / 2
        @trim.top = 0
      else
        @trim.width = @image.width()
        @trim.height = @trim.width / @prop.aspect_ratio
        @trim.top = (@image.height() - @trim.height) / 2
        @trim.left = 0
    @toVision()
    return
  
  onTouchStartTrimRect: =>
    event.preventDefault()
    @temp.start_touch_position = @getTouchPosition(event.touches[0])
    @temp.start_trim = {}
    for key, value of @trim
      @temp.start_trim[key] = value
    return

  onTouchMoveTrimRect: =>
    event.preventDefault()
    touch_position = @getTouchPosition(event.touches[0])

    dest_x = @temp.start_trim.left + touch_position.dif_x
    dest_y = @temp.start_trim.top + touch_position.dif_y
    if dest_x < 0
      dest_x = 0
    else if dest_x + @trim.width > @image.width()
      dest_x = @image.width() - @trim.width

    if dest_y < 0
      dest_y = 0
    else if dest_y + @trim.height > @image.height()
      dest_y = @image.height() - @trim.height

    @trim.left = dest_x
    @trim.top = dest_y
    @toVision()
    return

  onTouchEndTrimRect: =>
    event.preventDefault()
    return
  
  onTouchStartResizeKnob: =>
    event.preventDefault()
    event.stopPropagation()
    @temp.start_touch_position = @getTouchPosition(event.touches[0])
    @temp.start_trim = {}
    for key, value of @trim
      @temp.start_trim[key] = value
    return

  onTouchMoveResizeKnob: =>
    event.preventDefault()
    event.stopPropagation()
    touch_position = @getTouchPosition(event.touches[0])

    if Math.abs(touch_position.dif_x) >= Math.abs(touch_position.dif_y)
      dest_w = @temp.start_trim.width + touch_position.dif_x
      dest_h = dest_w / @prop.aspect_ratio
    else
      dest_h = @temp.start_trim.height + touch_position.dif_y
      dest_w = dest_h * @prop.aspect_ratio
    
    if @trim.left + dest_w > @image.width()
      dest_w = @image.width()- @trim.left
      dest_h = dest_w / @prop.aspect_ratio
    if dest_w < 50
      dest_w = 50
      dest_h = dest_w / @prop.aspect_ratio
    
    if @trim.top + dest_h > @image.height()
      dest_h = @image.height()- @trim.top
      dest_w = dest_h * @prop.aspect_ratio
    if dest_h < 50
      dest_h = 50
      dest_w = dest_h * @prop.aspect_ratio
      
    @trim.width = dest_w
    @trim.height = dest_h
    
    @toVision()
    return

  onTouchEndResizeKnob: =>
    event.preventDefault()
    return

  getTouchPosition: (touch) ->
    obj = {}
    obj.x = touch.pageX
    obj.y = touch.pageY
    if @temp.start_touch_position?
      obj.dif_x = touch.pageX - @temp.start_touch_position.x
      obj.dif_y = touch.pageY - @temp.start_touch_position.y
    return obj

  toVision: ->
    console.log "TrimImage.toVision @trim(見かけ上のトリム位置)の値を見た目に反映"

    trim = {}
    console.log @trim
    for key, value of @trim
      trim[key] = Math.round(value)

    @trim_rect.css(
      top: trim.top + "px",
      left: trim.left + "px",
      width: trim.width + "px",
      height: trim.height + "px"
    )
    
    @guide_bg.left.css(
      width: trim.left + "px"
    )
    
    @guide_bg.right.css(
      width: @image.width() - trim.left - trim.width + "px"
    )
    
    @guide_bg.top.css(
      left: trim.left + "px",
      width: trim.width + "px",
      height: trim.top + "px"
    )
    
    @guide_bg.bottom.css(
      left: trim.left + "px",
      width: trim.width + "px",
      height: @image.height() - trim.top - trim.height + "px"
    )
    return
  onSubmit: =>
    #トリム位置を表示画像との割合（％）でサーバに送信する
    #小数点以下３桁に丸める
    @trim_input.left.attr("value", @prop.per_left)
    @trim_input.top.attr("value", @prop.per_top)
    @trim_input.width.attr("value", @prop.per_width)
    @trim_input.height.attr("value", @prop.per_height)
    console.log @form
  startEdit: =>
    if !@prop.fr?
      return
    window.popup.show("#trimmer_wrap")
    @initGuide()
  cancelEdit: =>
    window.popup.hide()
  finishEdit: =>
    #トリム位置を表示画像との割合（％）でサーバに送信する
    #小数点以下３桁に丸める
    #小数点以下３桁に丸めるper_left)
    @trim.left = @trim_rect.position().left
    @trim.top = @trim_rect.position().top 
    @trim.width = @trim_rect.width()
    @trim.height = @trim_rect.height()
    @prop.per_left = Math.round(@trim_rect.position().left / @image.width() * 1000) / 1000
    @prop.per_top = Math.round(@trim_rect.position().top / @image.height() * 1000) / 1000
    @prop.per_width = Math.round(@trim_rect.width() / @image.width() * 1000) / 1000
    @prop.per_height = Math.round(@trim_rect.height() / @image.height() * 1000) / 1000
    #プレビュー箱をトリムで指定した大きさに合わせる
    @preview
      .css(
        width: @trim.width + "px",
        height: @trim.height + "px",
        overflow: "hidden"
      )
      #トリム位置を決定する度にpreview_imgを更新
      .empty()
    #元画像をプレビュー箱にクローンして、表示位置をトリム位置に合わせる
    @preview_img = @image.clone()
      .css(
        position:"relative",
        top: -@trim.top + "px",
        left: -@trim.left + "px",
        width: @image.width() + "px",
        height: @image.height() + "px",
        "z-index": 0
      ).appendTo(@preview)
    window.popup.hide()
    
window.TrimImage = TrimImage

byteStringToOrientation = (img) ->
  head = 0
  orientation = 1
  while true
    if img.charCodeAt(head) == 255 and img.charCodeAt(head + 1) == 218
      break
    if img.charCodeAt(head) == 255 and img.charCodeAt(head + 1) == 216
      head += 2
    else
      length = img.charCodeAt(head + 2) * 256 + img.charCodeAt(head + 3)
      endPoint = head + length + 2
      if img.charCodeAt(head) == 255 and img.charCodeAt(head + 1) == 225
        segment = img.slice(head, endPoint)
        bigEndian = segment.charCodeAt(10) == 77
        if bigEndian
          count = segment.charCodeAt(18) * 256 + segment.charCodeAt(19)
        else
          count = segment.charCodeAt(18) + segment.charCodeAt(19) * 256
        i = 0
        while i < count
          field = segment.slice(20 + 12 * i, 32 + 12 * i)
          if (bigEndian and field.charCodeAt(1) == 18) or (!bigEndian and field.charCodeAt(0) == 18)
            orientation = if bigEndian then field.charCodeAt(9) else field.charCodeAt(8)
          i++
        break
      head = endPoint
    if head > img.length
      break
  return orientation

getOrientation = (imgDataURL) ->
  byteString = atob(imgDataURL.split(',')[1])
  byteStringToOrientation(byteString)
