View= require 'framework/view'
alertTemplate= require './templates/alert'

module.exports= class AppLayoutView extends View

  template: 'app-layout'

  ui:
    outlet: '#outlet'
    alert: '#message'

  appEvents:
    'route:no-match': 'show404Alert'

  afterRender: ->
    @alert.hide()

  show404Alert: (path)->
    path or= location.hash.substring(1)
    @alert.html alertTemplate {path}
    @alert.show()


