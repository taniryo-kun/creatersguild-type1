do ($=jQuery) ->
  $.fn.ellipsis = ->
    #展開可能な要素にクリックで展開・折りたたみするイベントをバインド（動的イベント）
    $(document).off("click.ellipsis", ".ellipsis.expandable, .ellipsis.expand")
    $(document).on("click.ellipsis", ".ellipsis.expandable, .ellipsis.expand", ->
      $this = $(@)
      if $this.hasClass("noclickevent")
        return
      $to = if $this.hasClass("expand") then $this.prev() else $this.next()
      $this.hide()
      $to.show()
      return
    )
    
    #セレクタに該当する要素に折りたたみを適用
    return @each ->
      el = $(@)
      if el.hasClass("ellipsised")
        return
      else el.addClass("ellipsised")
      
      if el.css("overflow") == "hidden"
        text = el.html()
        multiline = el.hasClass("multiline")
        t = $(@cloneNode(true))
          .hide()
          .css(
            "position": "absolute",
            "overflow": "visible",
            "max-width": "none",
            "max-height": "none"
          )
          .width(if multiline then el.width() else 'auto')
          .height(if multiline then 'auto' else el.height())
        el.after(t)
        
        height = () ->
          return t.height() > el.height()
        width = () ->
          return t.width() > el.width()
        func = if multiline then height else width
        while text.length > 0 and func()
          text = text.substr(0, text.length - 1)
          t.html(text + "…")
        
        if el.hasClass("expandable")
          e = $(this.cloneNode(true))
            .css(
              'max-width': 'none',
              "max-height": "none"
            )
            .width(if multiline then el.width() else 'auto')
            .height(if multiline then 'auto' else el.height())
            .removeClass("expandable")
            .addClass("expand")
          el.after(e)
          
          if el.height() == e.height() and t.height() == e.height()
            el.removeClass("expandable")
            e.remove()
        el.html(t.html())
        t.remove()
  return
