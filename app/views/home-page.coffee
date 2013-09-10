View= require 'framework/view'

module.exports= class HomePageView extends View

  template: 'home-page'

  initialize: ->
    @documentTitle= @app.title