
module.exports= class Controller
  
  constructor: (options={})->
    _.extend @, options
    @app ?= Giraffe.app
    @initialize?(options)
    Giraffe.bindEventMap @, @app, @appEvents
    Giraffe.View::_bindDataEvents.call this
    
  dispose: ->
    Giraffe.dispose @

_.extend Controller::, Backbone.Events
