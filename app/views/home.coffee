View= require 'framework/view'

module.exports= class HomeView extends View

  template: require './templates/home'

  initialize: ->
    @documentTitle= @app.title