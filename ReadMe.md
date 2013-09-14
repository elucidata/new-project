# New Project Skeleton

This is a [Brunch](http://brunch.io) project skeleton for elucidata apps (that
anyone can use) that includes: Backbone, Giraffe, Lo-Dash, and Bootstrap. For 
development using: CoffeeScript, Stylus, and Eco templates.

To create a new app using this skeleton:

    brunch new gh:elucidata/new-project MyNewApp

## Framework

There are base files under `app/framework` that wrap, and add to, [Giraffe](https://github.com/barc/backbone.giraffe)
classes.

### `App`

The `App` class extends `Giraffe.App` adding a `#navigator` object that encapsulates
`Giraffe.Router`. It will automatically create an app-level `UndoManager`.

A `route:no-match` event is emitted whenever a route is not found.

Instance methods:

- `navigateTo( eventName, args... )`
- `logEvents( stopLogging=false )` -- Logs all events emitted from the app.
- `requireAll( matching )` -- `matching` can be a String or RegExp, returns an object with all the required models merged together.

### `Model`

The `Model` class extends `Giraffe.Model`, adding support for automatically
tracking `createdOn`/`updatedOn` timestamps. Adds static method for defining attribute
methods or properties for the Model -- so you aren't always passing around fragile strings.

Static methods:

- `trackTimestamps()` -- Enables automatic updating of `createdOn` and `updatedOn` timestamps.
- `attr(name, options={})` -- Creates attribute methods (like jquery) or property getters/setters for specified attribute. Options supported:
    - `alias` -- String. Make the method/property name on the model object different than the attribute name.
    - `default` -- Object/Any, default null. Default value for attribute.
    - `property` -- Boolean, default false. If true, creates getters/setters, otherwise creates attribute methods.
    - `readonly` -- Boolean, default false. If true, a setter isn't created.
 
Instance methods:

- `touch()` -- Manually update the `updatedOn` attribute.

### `Collection`

The `Collection` class extends `Giraffe.Collection`. On construction, if there's a 
`localStorage` property, and it's a String, it'll automatically create a new `Backbone.localStorage`.


### `Controller`

The `Controller` class participates in Giraffe's `appEvents`, `dataEvents`, and nesting
-- much like a View. It's default `dispose()` implementation disposes any children.

Methods from View supported:

- `addChild`
- `addChildren`
- `invoke`
- `removeChild`
- `removeChildren`
- `setParent`


### `View`

The `View` class extends `Giraffe.View`, adding support for auto-requiring templates 
(if the `template` property is a String).

Instance methods:

- `animate( className )` -- experimental, will probably go away soon
- `isVisible()` -- Uses `HTMLElement#getBoundingClientRect()` and is therefore experimental, will probably go away soon
- `isHidden()` -- inverse of `isVisible()`

### `CollectionView`

The `CollectionView` class extends `Giraffe.Contrib.CollectionView`, adding support for
rendering an `emptyView` when the associated Collection length is 0.

Instance property:

- `emptyView` -- View class to be rendered when the associated `Collection` is empty.

### `UndoManager`

The `UndoManager` class extends `Controller`. Use it to track user interactions with your
Collections that users can later undo.

[See the source code](https://github.com/elucidata/new-project/blob/master/app/framework/undo-manager.coffee) for usage instructions and examples.

Static methods:

- `crudHelpers( collection )` -- Returns a helper object that can handle simple CRUD operations in an undoable manner.

Instance methods:

- `record( collections..., fnBlock )`
- `undo()`
- `redo()`
- `clear()`
- `canUndo()`
- `canRedo()`


## Cake Tasks

Included are Cake tasks for managing app versions, building with brunch, 
generating Models/Views/Controllers, and displaying source annotations:

    Cakefile defines the following tasks:

    cake build                # Builds the app into ./public
    cake build:optimize       # Builds optimized app into ./public
    cake build:watch          # Watch ./app and autobuild to ./public on change
    cake build:server         # Starts dev server
    cake clean                # Removes ./public
    cake gen                  # Runs scaffold generator
    cake gen:ls               # List known generators
    cake notes                # Show all annotations in source
    cake notes:todo           # Show 'TODO:' annotations in source
    cake notes:fixme          # Show 'FIXME:' annotations in source
    cake notes:optimize       # Show 'OPTIMIZE:' annotations in source
    cake notes:hack           # Show 'HACK:' annotations in source
    cake notes:review         # Show 'REVIEW:' annotations in source
    cake notes:note           # Show 'NOTE:' annotations in source
    cake ver                  # Prints current app version
    cake ver:update           # Updates all the files that contain version info

      -p, --path         (gen) Where to place the generated file
      -f, --force        (ver) Force updating for version files


## Generators

You can create new Models, Views, or Controllers very easily. You'll need to have
[scaffolt](https://github.com/paulmillr/scaffolt) installed globally:

    npm install -g scaffolt

Then create a new **Model** like this:

    cake gen model user

It will generate:

- app/models/user.coffee
- test/models/user-test.coffee

For a **View**:

    cake gen view about

Generates:

- app/views/about.coffee
- app/views/templates/about.eco
- app/views/styles/about.styl
- test/views/about-test.coffee

And **Controller**:

    cake gen controller audio

Generates:

- app/controllers/audio.coffee
- test/controllers/audio-test.coffee


## Todo

Once your project is created, you'll want to:

- Update the application name in `package.json` and `bower.json`
- Replace this `ReadMe.md` file
- Build your awesome app!


