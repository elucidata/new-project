
module.exports= class Controller
  _.extend @::, Backbone.Events  
  
  appEvents: null
  
  constructor: (options={})->
    _.extend @, options
    @app ?= Giraffe.app
    @children ?= []
    @parent ?= null
    @initialize?(options)
    @app.addChild this unless @parent?
    Giraffe.bindEventMap @, @app, @appEvents
    Giraffe.View::_bindDataEvents.call this
    
  dispose: ->
    Giraffe.dispose @, ->
      @setParent null
      @removeChildren()

  # Pull some methods over from the View impl 
  # so Controllers can be nested as well.
  setParent: Giraffe.View::setParent
  addChild: Giraffe.View::addChild
  addChildren: Giraffe.View::addChildren
  removeChild: Giraffe.View::removeChild
  removeChildren: Giraffe.View::removeChildren
  invoke: Giraffe.View::invoke


