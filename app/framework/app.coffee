
patchBackbone= ->
  origLoadUrl= Backbone.history.loadUrl

  Backbone.history.loadUrl= (fo)->
    matched= origLoadUrl.call(Backbone.history, fo)
    # Only trigger no-match events when testing an actual fragment
    Giraffe.app.trigger('route:no-match', fo) if fo? and not matched
    matched

# Internal class
class Navigator
  constructor: (@app)->
  go: (params...)-> @app.router.cause params...
  matches: (params...)-> @app.router.isCaused params...
  path: (params...)-> @app.router.getRoute params...

module.exports= class App extends Giraffe.App

  initialize:->
    @navigator= new Navigator this
    patchBackbone()
    super()
  
  navigateTo: (params...)-> 
    @navigator.go params...

  logEvents: ->
    @on 'all', (args...)-> console.log 'app.event', args
