
module.exports= class Controller
  
  constructor: (options={})->
    _.extend @, options
    @app ?= Giraffe.app
    Giraffe.bindEventMap @, @app, @appEvents
    @initialize?()
    
  dispose: ->

_.extend Controller::, Backbone.Events
