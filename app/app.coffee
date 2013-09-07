App= require 'framework/app'
UIController= require 'controllers/main'
VERSION= require 'models/version'

class Application extends App
  
  # TODO: Update app.title!
  title: 'Untitled'
  version: VERSION

  routes:
    '': 'show:home'
  
  afterRender: ->
    @uiController= new UIController
    @attach @uiController.layout


module.exports= new Application