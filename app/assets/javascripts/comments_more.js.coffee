class CommentsMore
  constructor: (selector)->
    if selector == undefined
      selector = "#more_button"

    @button = $(selector)
    @button.on("click", @onClickButton)
  
    @waiting = false
    
    @context = window.comments
    
    @data = {}
    
  set: (bool) ->
    if bool
      @button.show()
    else
      @button.hide()
    return
  
  setContext: (context) ->
    @context = context
    @set(context.has_next)
    @clearOptionalData()
  
  addOptionalData: (key, value) ->
    @data[key] = value
  
  clearOptionalData: () ->
    @data = {}

  onClickButton: =>
    return if @waiting
    # データに取得済みのコメントの中で最も古いものの日付を追加
    @data.older_than = @context[@context.length - 1].created_at
    $.ajax
      type: "get"
      url: location.href + "/comments"
      dataType: "json"
      data: @data
      success: (response, status, xhr) =>
        @waiting = false
        context = window
        for point in window.points
          if point.selected
            context = point
        @context.append(response.comments)
        @context.has_next = response.has_next
        if !response.has_next
          @set(false)
        return
      beforeSend: =>
        @waiting = true
        return
    return

window.CommentsMore = CommentsMore