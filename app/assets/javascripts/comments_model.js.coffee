class Comments extends Array
  constructor: (comments) ->
    super()
    for comment in comments
      @push(comment)
    
    @$view = $("#comments")
    @html = ""
  
  append: (comments) ->
    for comment in comments
      @push(comment)
    @updateView(
      comments: comments
      type: "append"
    )

  prepend: (comments) ->
    comments.reverse()
    for comment in comments
      @unshift(comment)
    @updateView(
      comments: comments
      type: "prepend"
    )
  
  draw: ->
    if @html != ""
      @redraw()
    else
      @clearView()
      @updateView(
        comments: @
        type: "append"
      )

  redraw: ->
    @$view.html(@html)
  
  clearView: ->
    @$view.empty()
  
  updateView: (args) ->
    args_initial = {
      comments: []
      type: "append"
    }
    args = $.extend(args_initial, args)
    comments_html = ""
    for comment in args.comments
      if args.type == "append"
        comments_html += comment.html
      else
        comments_html = comment.html + comments_html
    new_comments = $(comments_html)
    if args.type == "append"
      new_comments.appendTo(@$view)
    else
      new_comments.prependTo(@$view)
    
    #$viewに変更があった場合の共通処理
    $(".ellipsis").ellipsis()
    
    #再描画時用にhtmlを保持  
    @html = @$view.html()
  

window.Comments = Comments
