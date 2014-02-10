$ ->
  $('a.fancybox, a.gallery-picture').fancybox(
    openEffect:   'elastic'
    closeEffect:  'elastic'
    padding:      2
    closeBtn:     false
    helpers: {
      title: {
        type:     'inside'
      }
      buttons: {
        position: 'bottom'
      }
    }
  )

  true