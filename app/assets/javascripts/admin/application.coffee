#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require moment
#= require moment/de
#= require bootstrap-datetimepicker
#= require ckeditor/init
#= require jquery.fancybox.pack
#= require jquery.fancybox-buttons
#= require jquery.fancybox-media
#= require jquery-ui
#= require ../fancybox
#= require_tree .

$ ->
  $('#admin .sortable').sortable
    update: (event, ui) ->
      positions = {}
      $(this).children().each (index, value) ->
        positions[$(value).data('item-id')] = index

      $.ajax(
        type: 'PUT'
        url: $(this).data('update-url')
        dataType: 'json'

        # the :thing hash gets passed to @thing.attributes
        # row_order is the default column name expected in ranked-model
        data: { 'positions': positions }
      )
