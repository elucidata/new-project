View= require 'framework/view'

module.exports= class LayoutView extends View

  template: require './templates/layout'  

  ui:
    outlet: '#outlet'
