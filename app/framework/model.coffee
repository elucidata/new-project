
module.exports= class Model extends Giraffe.Model

  # Public: Generates attribute methods or properties accessors.
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
  