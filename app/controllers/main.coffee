Controller= require 'framework/controller'
LayoutView= require 'views/layout'
HomeView= require 'views/home'

module.exports= class UIController extends Controller

  appEvents:
    'show:home': 'showHomeView'

  initialize: ->
    @layout= new LayoutView

  showHomeView: ->
    @_updateLayout new HomeView

  _updateLayout: (view, checkType=no)->
    return if @currentView is view
    return if checkType is yes and @currentView instanceof view.constructor
    # This is where you would add support for page 'transitions' or the like.
    @currentView= view
    @currentView.attachTo @layout.outlet, method:'html'