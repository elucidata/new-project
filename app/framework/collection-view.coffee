View= require './view'
###

  Class: CollectionView
  
  Extends Giraffe.Contrib.CollectionView and includes additions from <View>

###
module.exports= class CollectionView extends Giraffe.Contrib.CollectionView
  
  # Method: animate
  # See <View.animate>
  animate: View::animate
  _removeAnimatedClass: View::_removeAnimatedClass
  
  # Method: isVisible
  # See <View.isVisible>
  isVisible: View::isVisible
  
  # Method: isHidden
  # See <View.isHidden>
  isHidden: View::isHidden

  afterRender: ->
    super
    @_emptyListCheck()

  _onAdd: (item)->
    @_emptyListCheck()
    super

  _onRemove: (item)->
    @_emptyListCheck()
    super

  _emptyListCheck: ->
    return unless @emptyView?
    if @collection.length is 0
      return if @_emptyView? and @_emptyView.isAttached()
      @_emptyView= new @emptyView()
      @attach @_emptyView
    else if @_emptyView?
      @_emptyView.dispose()
      @_emptyView= null

