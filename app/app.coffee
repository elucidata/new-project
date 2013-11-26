App= require 'framework/app'
UIController= require 'controllers/main'
VERSION= require 'models/version'

# Class: Application
# Your application class, extends <App>
class Application extends App
  
  # Property: title  
  # TODO: Update app.title!
  title: 'Untitled'
  # Property: version
  version: VERSION

  # Property: routes
  # All the application routes and which appEvents they fire.
  routes:
    '': 'show:home'

  afterRender: ->
    @uiController= new UIController
    @attach @uiController.layout


module.exports= new Application