class PointTagger
  constructor: (selector) ->
    @activation = true
    @prop = {
      img : {
        aspect: 4/3
      },
      marker : {
        size: 30
      }
    }
    @view = $(selector)
    @base = @view.children("#img_box")
    @img = @base.children("img")
    @points = window.points
    @temp = {}
    
    #メイン画像初期化（リサイズ・クロップ）
    initImage = =>
      @markerLayer = $("<div>")
        .css(
          position: "absolute"
          top: "0px"
          left: "0px"
          width: "100%"
          height: "100%"
          overflow: "hidden"
        )
        .appendTo(@base)
      
      for point in @points
        @addMarker point
      return
    
    #画像読み込み状態に合わせてメイン画像初期化を実行
    if @img[0].complete then initImage() else @img.bind("load", initImage)
    
    #各要素にタッチイベントをバインド
    #@view.bind("touchend",@touchEnd)
    @view.bind("click",@click)

    #ポイント付きコメントフォーム初期化
    @cpform = $("#commentFormWithPoint")
    @cpform.find("input#cppost").bind("click", @createCommentWithPoint)
    @cpform.find("input#cpcancel").bind("click", @hideCommentForm)
    return
  
  click: (event) =>
    return if !@activation
    cp = @recalculate(event)
    @onUserOperation(cp)

  onUserOperation: (tp) ->
    selected = @getSelectedMarkers(tp)
    if selected.length == 0
    #タッチ位置が新規ポイントであった場合の処理
      if confirm "Add Point?"
        #ユーザが新規ポイントを追加することに同意した場合の処理
        @diselect()
        @temp.tp = tp
        #@setExamplePoint(tp)
        @popCommentForm(tp)
      else
        return
    else
      #タッチ位置が既ポイントであった場合の処理
      if !@temp.selection_prev
        @temp.selection_prev = []

      same_selection = true
      if selected.length == @temp.selection_prev.length
        for i in [0...selected.length]
          if @temp.selection_prev[i] != selected[i]
            same_selection = false
      else
        same_selection = false

      if same_selection
        index = @temp.selection_index_prev + 1
        if index >= selected.length
          @temp.selection_prev = []
          @temp.selection_index_prev = 0
          @diselect()
          return
      else
        index = 0
      @temp.selection_prev = selected
      @temp.selection_index_prev = index
      @select(selected[index])
    return

  getTouchPosition: (arg) ->
    if arg.type?
      touch = arg.touches[0] || arg.chagedTouches[0]
    else
      touch = arg
    return @recalculate(touch)

  recalculate: (context) ->
    result = {}
    result.viewX = context.pageX - @view.offset().left
    result.viewY = context.pageY - @view.offset().top
    result.baseX = context.pageX - @base.offset().left
    result.baseY = context.pageY - @base.offset().top
    result.imgX = context.pageX - @img.offset().left
    result.imgY = context.pageY - @img.offset().top
    return result

  #新規ポイント作成後の最初のコメント投稿時に動作
  createCommentWithPoint: =>
    console.log "start @createCommentWithPoint"
    data = {}
    data.point = {
      coordinateX: @temp.tp.imgX / @img.width()
      coordinateY: @temp.tp.imgY / @img.height()
    }
    data.comment = {
      comment: @cpform.find("textarea")[0].value
      comment_status: @cpform.find("option:selected").val()
    }
    data.newer_than = comments[0].created_at if comments[0]?

    onSuccess = (response, status, xhr) =>
      @hideCommentForm()
      #サーバーから保存成功のレスポンスを受け取った場合
      if response.status == true
        point = response.point
        @addMarker point
        window.points.push(point)
        has_next = window.comments.has_next
        window.comments.prepend(response.comments)
        window.comments.has_next = has_next
        @cpform.find("textarea")[0].value = ""
        #本来は連投禁止処理を記述
      else
        alert "画像上のコメント投稿に失敗しました。"
      return

    $.ajax(
      type: "POST",
      url: location.href + "/points",
      dataType: "json",
      data: data,
      success: onSuccess#リクエストが完了し、レスポンス取得に成功した場合にコールバックする関数を指定
    )
    return

  #新規ポイントタップ後にコメントフォームをポップアップさせるメソッド
  popCommentForm: (tp) ->
    console.log "pop"
    point = {
      x : tp.imgX / @img.width(),
      y : tp.imgY / @img.height()
    }
    $marker = @cpform.find(".marker")
    $marker.css(
      top: point.y * 100 + "%"
      left: point.x * 100 + "%"
    )
    popup.show()
    return

  hideCommentForm: =>
    popup.hide()
    return

  getSelectedMarkers: (tp) ->
    selected = []
    for point in @points
      dx = point.coordinateX * @img.width() - tp.imgX
      dy = point.coordinateY * @img.height() - tp.imgY
      d = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))
      if d < @img.width() * @prop.marker.size / 200
        selected.push(point)
    return selected

  createrPoint: (tp) ->
    #Ajaxリクエストが成功し、レスポンスを取得した際に動作する関数
    onSuccess = (response, status, xhr) =>
      point = response.point
      @addMarker point
      window.points.push(point)
      @select point
    #Ajaxリクエストを送信 (points#create) 
    $.ajax(
      type: "POST",
      url: location.href + "/points",
      dataType: "json",
      data: {
        point : {
          coordinateX : tp.imgX / @img.width(),
          coordinateY : tp.imgY / @img.height()
        }
      },
      success: onSuccess#リクエストが完了し、レスポンス取得に成功した場合にコールバックする関数を指定
    )
    return
    
    
  addMarker: (point) ->
    marker = $("<div>")
      .css(
        left: point.coordinateX * 100 + "%"
        top: point.coordinateY * 100 + "%"
        width: @prop.marker.size + "%"
      )
      .addClass("marker")
      .appendTo(@markerLayer)
    point.element = marker
    point.selected = false
    return

  activate: ->
    @activation = true
    return

  inactivate: ->
    @activation = false
    return

  select: (selectedPoint) ->
    active_point = @getActivePoint()
    if active_point != null
      active_point.selected = false
      active_point.element.removeClass("selected")
    selectedPoint.selected = true
    selectedPoint.element.addClass("selected")
    
    if !selectedPoint.comments?# selectedPointがcommentsデータ配列を保持していない場合
      # リクエストを送る前処理
      beforeSend = =>
        @inactivate()
      # Ajaxリクエストが成功した時
      onSuccess = (response, status, xhr) =>
        comments = response.comments
        has_next = response.has_next
        # 選択Pointのcommentsプロパティにresponseのcommentsデータを格納、has_nextをセット
        selectedPoint.comments = new Comments(comments)
        selectedPoint.comments.has_next = has_next
        # コメント表示を再描画する
        selectedPoint.comments.draw()
        window.comments_more.setContext(selectedPoint.comments)
        window.comments_more.addOptionalData("point_id", selectedPoint.id)
        @activate()

      $.ajax(
        type: "GET",
        url: location.href + "/comments",
        dataType: "json",
        data: {
                point_id : selectedPoint.id
        },
        success: onSuccess,
        beforeSend: beforeSend
      )
    else# selectedPointがcommentsデータ配列を保持している場合
      # コメント表示を再描画する
      selectedPoint.comments.draw()
      window.comments_more.setContext(selectedPoint.comments)
      window.comments_more.addOptionalData("point_id", selectedPoint.id)
    #全件コメント表示のボタンを表示に
    $("#all_comments").css("display":"")
    #コメント一覧タイトル部の表示変化
    $("#comments_title").addClass("about_point")
    return
  
  diselect: ->
    #選択されているポイントを未選択状態に戻す
    active_point = @getActivePoint()
    if active_point != null
      active_point.selected = false
      active_point.element.removeClass("selected")
    #全コメントを表示させる
    window.comments.draw()
    window.comments_more.setContext(window.comments)
    #全件コメント表示のボタンを非表示に
    $("#all_comments").css("display":"none")
    #コメント一覧タイトル部の表示変化
    $("#comments_title").removeClass("about_point")
    return
  
  getActivePoint: ->
    result = null
    for point in window.points
      if point.selected
        result = point
    return result
window.PointTagger = PointTagger
