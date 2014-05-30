# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#必要な
#= require comments_model
#= require comments_more
#= require workstages_point
#= require trim_image
#= require ellipsis
#= require popup

$(document).ready ->
  $(".ellipsis").ellipsis()

  $.ajaxSetup(
      beforeSend: (xhr) ->
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
  )
  
  $('#new_comment')
    # submitした時にボタンを無効化
    .on 'ajax:beforeSend', (event, ajax, xhr) ->
      $(this).children(":submit").attr('disabled', true)
      # ポイント選択中ならばPOSTデータにpoint_idを追加
      context = window
      for point in window.points
        if point.selected
          xhr.data += "&point_id=" + point.id
          context = point
      #context(window又は選択中のPoint)の取得済み最新コメントの投稿日時をPOSTデータに追加
      if context.comments.length != 0
        xhr.data += "&newer_than=" + encodeURIComponent(context.comments[0].created_at)
      return
    # ajaxレスポンス取得時の処理
    .on 'ajax:success', (event, response, xhr) ->
      if response.status == true
        context = window
        for point in window.points
          if point.selected
            context = point
        has_next = context.comments.has_next
        context.comments.prepend(response.comments)
        context.comments.has_next = has_next
        $(this)[0].reset()
        $(this).children(":submit").attr('disabled', false)
      #空コメントを投稿した場合の処理を追加
      else
        caution = "コメントは必須です。\n入力してください。"
        alert caution
        $(this).children(":submit").attr('disabled', false)
      return

  if $("#view").length != 0
    window.point_tagger = new PointTagger("#view")
  
  if $("#workstage_start_image_attributes_image").length != 0
    window.trimmer = new TrimImage("#workstage_start_image_attributes_image", 4/3)

  if $("#workstage_after_image_attributes_image").length != 0
    window.trimmer = new TrimImage("#workstage_after_image_attributes_image", 4/3)

  $("#all_comments")
    .css("display":"none")
    .bind "click", ->
      window.point_tagger.diselect()
      
  if $("#popup").length != 0
    window.popup = new Popup()
  
  #.comment .right_columnクリック時に、クラス「show_detail」をトグル
  $("#comments").on("click.show_detail", ".comment .right_column", (e)->
    $this = $(@)
    $this.toggleClass("show_detail")
    return
  )

  $(".want_button")
  .on 'ajax:success', (event, data, status, xhr) ->
      if data.status == true
        $("#want_point").html(data.work.want_point)
  
  window.comments_more = new CommentsMore()
  # window.comments.has_nextで次ページの有無を調べ、存在しない場合はMoreボタン削除
  window.comments_more.set(window.comments.has_next) if window.comments?
  return
