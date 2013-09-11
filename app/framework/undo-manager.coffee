Controller= require './controller'

# TODO: Implement limiting size of undo stack. Currently will expand forever
# TODO: Show persisting undo stack to localStorage
# TODO: Test complex model updates with undo/redo (multi-model and collection)
# FIXME: Add proper unit tests

class Transaction
  constructor: (@manager, @objects, @block)->
    @actions= []

  execute: ->
    object.on('all', @_logEvents) for object in @objects
    @block(@manager)
    object.off('all', @_logEvents) for object in @objects
    this

  rollback: ->
    for action in @actions.reverse()
      {method, model, collection}= action
      
      # If we added a model, delete it
      if method is 'add'
        model.destroy()
      
      # If we removed a model, recreate it
      else if method is 'remove'
        restored= new collection.model action.attributes
        console.log "restored model", restored, collection
        collection.add restored
        restored.save()
      
      # If we modified a model, restore the changes
      else if method is 'change'
        model.set action.changes
      
      else
        console.log 'Unknown model action', method
    @actions= []
    this

  _logEvents: (args...)=>
    action= args.shift()
    if handler= @["_log_#{ action }"]
      # console.log "logging event", action, args
      @actions.push handler(args...)

  _log_add: (model, collection, changes)-> 
    { method:'add', id: model.id, model, collection }

  _log_remove: (model, collection, changes)-> 
    { method:'remove', id: model.id, attributes: _.clone(model.attributes), model, collection }

  _log_change: (model, changes)-> 
    newAtts= model.changedAttributes()
    changedAtts= _.pick model.previousAttributes(), _.keys(newAtts)
    { method:'change', id: model.id, attributes: _.clone(newAtts), changes: _.clone(changedAtts), model, collection: model.collection }



module.exports= class UndoManager extends Controller
  
  constructor: ->
    @_stack= []
    @_redoStack= []
    @length= 0

  transaction: (objects...)->
    block= objects.pop()
    txn= new Transaction this, objects, block
    @_stack.push txn
    txn.execute()
    @length= @_stack.length
    @_redoStack= []
    @trigger 'change'
    this

  undo: ->
    return false if @_stack.length is 0
    txn= @_stack.pop()
    # roll back changes
    txn.rollback()
    @_redoStack.push txn
    @length= @_stack.length
    @trigger 'undo'
    @trigger 'change'
    this

  redo: ->
    return false if @_redoStack.length is 0
    txn= @_redoStack.pop()
    # roll back changes
    txn.execute()
    @_stack.push txn
    @length= @_stack.length
    @trigger 'redo'
    @trigger 'change'
    this

  canUndo: -> @_stack.length > 0
  canRedo: -> @_redoStack.length > 0
  rollback: @::transaction

  @crudHelpers: (collection)->
    new CrudHelpers collection



class CrudHelpers
  constructor: (@collection)->
    @app= @collection.app
    @modelClass= @collection.model

  doAdd: (data, callback)->
    @app.undoMgr.transaction @collection, =>
      model= new @modelClass data
      @collection.add model
      callback? model
      model.save()

  doRemove: (idOrModel, callback)->
    id= @_getModelId idOrModel
    @app.undoMgr.transaction @collection, =>
      model= @_getModel id
      console.log "Looking to remove model.id", id, model
      model.destroy()
      callback? model

  doUpdate: (idOrModel, data, callback)->
    id= @_getModelId idOrModel
    @app.undoMgr.transaction @collection, =>
      model=  @_getModel id
      model.set data
      callback? model
      model.save()

  _getModel: (id)->
    if _.isString id
      @collection.get id
    else
      id
  _getModelId: (model)->
    if _.isString model
      model
    else
      model.id