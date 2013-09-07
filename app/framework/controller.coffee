
module.exports= class Controller
  
  constructor: (options={})->
    _.extend @, options
    @app ?= Giraffe.app
    @initialize?()
    Giraffe.bindEventMap @, @app, @appEvents
    Giraffe.View::_bindDataEvents.call this
    
  dispose: ->

_.extend Controller::, Backbone.Events
