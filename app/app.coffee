App= require 'framework/app'
UIController= require 'controllers/main'

class Application extends App
  
  title: 'Untitled'
  version: '0.1.0'

  routes:
    '': 'show:home'
  
  afterRender: ->
    @uiController= new UIController
    @attach @uiController.layout


module.exports= new Application