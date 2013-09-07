
module.exports= class Controller
  appEvents: null
  
  constructor: (options={})->
    _.extend @, options
    @app ?= Giraffe.app
    @children ?= []
    @parent ?= null
    # TODO: Perhaps @app.addChild(this) is a sensible default behavior?
    @initialize?(options)
    @app.addChild this unless @parent?
    Giraffe.bindEventMap @, @app, @appEvents
    Giraffe.View::_bindDataEvents.call this

  invoke: (methodName, args...) ->
    ctrl = @
    while ctrl and !ctrl[methodName]
      ctrl = ctrl.parent
    if ctrl?[methodName]
      ctrl[methodName].apply ctrl, args
    else
      error? 'No such method name in ctrl hierarchy', methodName, args, @
      true
    
  dispose: ->
    Giraffe.dispose @, ->
      @setParent null
      @removeChildren()

  # Pull some methods over from the View impl
  setParent: Giraffe.View::setParent
  addChild: Giraffe.View::addChild
  addChildren: Giraffe.View::addChildren
  removeChild: Giraffe.View::removeChild
  removeChildren: Giraffe.View::removeChildren

_.extend Controller::, Backbone.Events
