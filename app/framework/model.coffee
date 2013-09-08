
module.exports= class Model extends Giraffe.Model

  initialize: ->
    # Timestamp tracking
    if @createdOn? and @updatedOn?
      @on 'add', model._didAdd
      @on 'change', model._didChange
    super

  touch: ->
    @_didChange()

  @trackTimestamps= ->
    @attr 'createdOn', readonly:yes
    @attr 'updatedOn', readonly:yes
    modelClass::_didChange= _didChange
    modelClass::_didAdd= _didAdd

  # Public: Generates attribute methods or property accessors.
  # 
  # name    - The String name of the Model attribute to wrap.
  # options - The hash Object of options... (default: {})
  #           alias:    The String to use for the accessor. (default: name)
  #           default:  The default value for this attribute.
  #           property: Boolean flag (default: false)
  #                     true  - Use property accessors.
  #                     false - User attribute method.
  #           readonly: Boolean flag (default: false)
  #                     true  - Only reads are supported.
  #                     false - Reads and writes are allowed.
  @attr: (name, options={}) ->
    method_name= options.alias or name
    if options.default? 
      (@::defaults ?= {})[name]= options.default
    if options.property is yes
      methods= (get: -> @get name)
      if options.readonly isnt yes
        methods.set= (val)-> @set name, val
      Object.defineProperty @::, method_name, methods
    else
      @::[method_name]= if options.readonly is yes
        () -> @get name
      else
        (val) -> if val? then @set(name, val) else @get(name)



_now= ->
  (new Date).getTime()

_didChange= ->
  @set 'updatedOn', _now(), silent:yes

_didAdd= ->
  unless @attributes.createdOn?
    @set 'createdOn', _now(), silent:yes
    @_didChange()
  this
