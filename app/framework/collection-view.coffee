View= require './view'

module.exports= class CollectionView extends Giraffe.Contrib.CollectionView
  animate: View::animate
  _removeAnimatedClass: View::_removeAnimatedClass
  isVisible: View::isVisible
  isHidden: View::isHidden
