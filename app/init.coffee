$('html').removeClass('no-js').addClass('js')

window.app= app= require 'app'

app.addInitializer (opts)->
  # Do some initialization stuff here...


app.once 'app:initialized', ->
  app.attachTo 'body', method:'html'
  unless Backbone.history.start()
    app.trigger('show:home')
  console.log "Ready."


$ -> # Initialize the application on DOM ready event.
  console.log "#{ app.title } v#{ app.version }"
  app.start debug:yes
