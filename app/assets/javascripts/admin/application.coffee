#= require jquery
#= require jquery_ujs
#= require moment
#= require moment/de
#= require ckeditor/init
#= require ckeditor/init
#= require jquery.fancybox.pack
#= require jquery.fancybox-buttons
#= require jquery.fancybox-media

#= require jquery-ui/sortable
#= require jquery-ui/datepicker
#= require jquery.datetimepicker.min

#= require foundation
#= require ./events
#= require ../events
#= require ../fancybox

Date.parseDate = (input, format) ->
  moment(input, format).toDate()

Date.prototype.dateFormat = (format) ->
  moment(this).format(format)

$ ->
  $(document).foundation();

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
