# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require ckeditor/init
#= require jquery.fancybox.pack
#= require jquery.fancybox-buttons
#= require jquery.fancybox-media
#= require jquery.ui.all
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

  $('a.fancybox, a.gallery-picture').fancybox
    openEffect:   'elastic'
    closeEffect:  'elastic'
    padding:      2
    closeBtn:     false
    helpers: {
      overlay: {
        locked: false
      }
      title: {
        type:     'inside'
      }
      buttons: {
        position: 'bottom'
      }
    }
