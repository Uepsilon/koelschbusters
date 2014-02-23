$ ->
  $('a.fancybox, a.gallery-picture').fancybox(
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
  )
  event.preventDefault()