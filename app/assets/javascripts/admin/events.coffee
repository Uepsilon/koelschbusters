$ ->
  $.datetimepicker.setLocale('de');

  $('[data-behavior="datetimepicker"]').datetimepicker
    format: 'DD.MM.YYYY HH:mm',
    formatDate: 'DD.MM.YYYY',
    formatTime: 'HH:mm'
    minDate: 0,
    step: 15,
    lazyInit: true

    # extraFormats: [ 'DD.MM.YYYY HH:mm', 'YYYY-MM-DD HH:mm:ss' ]
