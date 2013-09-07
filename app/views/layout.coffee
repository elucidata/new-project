View= require 'framework/view'
AlertHtml= require './templates/alert'

module.exports= class LayoutView extends View

  template: require './templates/layout'  

  ui:
    outlet: '#outlet'
    alert: '#message'

  appEvents:
    'route:no-match': 'show404Alert'

  afterRender: ->
    @alert.hide()

  show404Alert: (path)->
    path or= location.hash.substring(1)
    @alert.html AlertHtml {path}
    @alert.show()


