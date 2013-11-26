Giraffe.View.setTemplateStrategy 'jst'

###

  Class: View

  Extends Giraffe.View

###
module.exports= class View extends Giraffe.View

  constructor: ->
    @template= require("views/templates/#{ @template }") if _.isString @template
    super

  # Method: animate
  #
  # Adds a class that MUST contain a CSS transtion and will automatically 
  # remove it on transitionEnd event.
  # 
  # className     - The String className to apply to _this.el_ (required)
  # complete      - Callback function to call when animation is done. (default: ->)
  # safetyTimeout - Number of milliseconds to wait before forcing the end of an 
  #                 animation and calling the callback. Use as fallback for browsers
  #                 that don't support transitions or transistionEnd events. (default: 1000)
  animate: (className, complete=(->), safetyTimeout=1000)->
    callback= @_removeAnimatedClass(className, complete)
    @$el
      .addClass(className)
      .one 'webkitTransitionEnd transitionend msTransitionEnd oTransitionEnd', callback
    if _.isNumber(safetyTimeout)
      _.wait safetyTimeout, callback
  
  _removeAnimatedClass: (className, callback)->
    animationCompleted= no
    (e)=> 
      return if animationCompleted
      @$el.removeClass className
      animationCompleted= yes
      if typeof callback is 'string'
        @[callback](e)
      else
        callback?(e)

  # Method: isVisible
  # Relies on HTMLElement#getBoundingClientRect() to determine if the this.el is visible.
  isVisible: ->
    # NOTE: View#isVisible() relies on HTMLElement#getBoundingClientRect()!
    # TODO: Need a test harness to put View#isHidden() through it's paces.
    return no unless @el?
    this_rect= @el.getBoundingClientRect()
    return no if this_rect.width is 0 and this_rect.height is 0
    parent_rect= @el.parentNode.getBoundingClientRect()
    # @log.debug this_rect.top, parent_rect.
    this_rect.top <= parent_rect.bottom and this_rect.bottom >= parent_rect.top

  # Method: isHidden
  # Inverse of <View.isVisible>
  isHidden: -> !@isVisible()