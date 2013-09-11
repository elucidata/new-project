###

Public: UndoManager tracks changes to specified Collections (and/or Models) in
        a somewhat transactional way. You don't extend your class with this,
        nor does it automatically track every model/collection in your app!

        You are meant to use it with discreet user interactions that the user
        can then undo if they want.


Example: (CoffeeScript)

  # Assume elsewhere:
  Users= new UserCollection
  Users.fetch()

  # Your undoable transaction:
  @app.undoMgr.record Users ->
    user= Users.findWhere {id}
    user.destroy()

  # To rollback the changes made:
  @app.undoMgr.undo()
  # or to re-apply them:
  @app.undoMgr.redo()

  # -- More complex example --

  # Posts and Comments are Collections

  newComment: (postId, commentAtts)->
    @app.undoMgr.record Posts, Comments, ->
      post= Posts.findWhere id:postId
      commentAtts.postId= postId
      Comments.create commentAtts
      post.set commentCount:(Comments.find {postId}).length
      post.save()
  
  # @app.undoMgr.undo() will now rollback the changes to both collections. 

###

# TODO: Show persisting undo stack to localStorage
# TODO: Test complex model updates with undo/redo (multi-model and collection)
# FIXME: Add proper unit tests

Controller= require './controller'

module.exports= class UndoManager extends Controller
  
  constructor: ->
    @_stack= []
    @_redoStack= []
    @length= 0
    @on 'change', => @length= @_stack.length

  record: (objects...)->
    block= objects.pop()
    txn= new Transaction this, objects, block
    # TODO: Implement limiting size of undo stack. Currently it will expand forever
    @_stack.push txn
    txn.execute()
    @_redoStack= []
    @trigger 'record change'
    this

  undo: ->
    return false if @_stack.length is 0
    txn= @_stack.pop()
    # roll back changes
    txn.rollback()
    @_redoStack.push txn
    @trigger 'undo change'
    this

  redo: ->
    return false if @_redoStack.length is 0
    txn= @_redoStack.pop()
    # roll back changes
    txn.execute()
    @_stack.push txn
    @trigger 'redo change'
    this

  # NOTE: This will destroy all undo and redo history!
  clear: ->
    @_stack.length = 0
    @_redoStack.length = 0
    @trigger 'clear change'

  canUndo: -> @_stack.length > 0
  canRedo: -> @_redoStack.length > 0

  @crudHelpers: (collection)->
    new CrudHelpers collection

# Internal class that encapsulates the tracking of all the model/collection
# changes that occur within the block of a UndoManager#record call.
class Transaction
  constructor: (@manager, @objects, @block)->
    @actions= []
    @_buildLabel()

  label: (value)->
    if value?
      @_label= value
    else
      @_label


  execute: ->
    object.on('all', @_logEvents) for object in @objects
    @block(this, @manager)
    object.off('all', @_logEvents) for object in @objects
    this

  # REVIEW: Should models be autosaved on rollback?
  rollback: ->
    for action in @actions.reverse()
      {method, id, collection}= action
      
      # If we added a model, delete it
      if method is 'add'
        model= collection.get(id) or collection.findWhere(action.attributes)
        model.destroy()
      
      # If we removed a model, recreate it
      else if method is 'remove'
        restored= new collection.model action.attributes
        collection.add restored
        restored.save()
      
      # If we modified a model, restore the changes
      else if method is 'change'
        model= collection.get(id) or collection.findWhere(action.attributes)
        model.set action.changes
        model.save()
      
      else
        console.log 'Unknown model action', method
    @actions= []
    this

  getObjectName: (object)->
    object.name or object.constructor.name or 'unnamed object'

  _buildLabel: ->
    names= []
    for object in @objects
      names.push @getObjectName(object)
    @_label = "changes to #{names.join ', '}"

  _logEvents: (args...)=>
    action= args.shift()
    if handler= @["_log_#{ action }"]
      @actions.push handler(args...)
    # else
    #   console.warn "could not record event", action

  _log_add: (model, collection, changes)-> 
    { method:'add', id: model.id, attributes: _.clone(model.attributes), model, collection }

  _log_remove: (model, collection, changes)-> 
    { method:'remove', id: model.id, attributes: _.clone(model.attributes), model, collection }

  _log_change: (model, changes)-> 
    newAtts= model.changedAttributes()
    changedAtts= _.pick model.previousAttributes(), _.keys(newAtts)
    { method:'change', id: model.id, attributes: _.clone(newAtts), changes: _.clone(changedAtts), model, collection: model.collection }


# Helpers for quickly creating undoable actions for CRUD operations.
class CrudHelpers
  constructor: (@collection)->
    @app= @collection.app
    @modelClass= @collection.model

  doAdd: (data, callback)->
    @app.undoMgr.record @collection, (txn)=>
      model= @collection.create data
      callback? txn, model

  doRemove: (idOrModel, callback)->
    id= @_getModelId idOrModel
    @app.undoMgr.record @collection, (txn)=>
      model= @_getModel id
      model.destroy()
      callback? txn, model

  doUpdate: (idOrModel, data, callback)->
    id= @_getModelId idOrModel
    @app.undoMgr.record @collection, (txn)=>
      model=  @_getModel id
      model.set data
      model.save()
      callback? txn, model

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