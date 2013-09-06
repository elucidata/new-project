
# Internal class
class Navigator
  constructor: (@app)->
  go: (params...)-> @app.router.cause params...
  matches: (params...)-> @app.router.isCaused params...
  path: (params...)-> @app.router.getRoute params...

module.exports= class App extends Giraffe.App

  initialize:->
    @navigator= new Navigator this
    super()
  
  navigateTo: (params...)-> 
    @navigator.go params...
