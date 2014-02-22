((d, s, id) ->
  js = undefined
  fjs = d.getElementsByTagName(s)[0]
  return  if d.getElementById(id)
  js = d.createElement(s)
  js.id = id
  js.src = "//connect.facebook.net/de_DE/all.js#xfbml=1&appId=732856840072449"
  fjs.parentNode.insertBefore js, fjs
  return
) document, "script", "facebook-jssdk"