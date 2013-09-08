Model= require './model'

module.exports= class Collection extends Giraffe.Collection
  model: Model
  
  initialize: ->
    # Localstorage
    if @localStorage? and _.isString @localStorage
      @localStorage= new Backbone.LocalStorage @localStorage
    super

