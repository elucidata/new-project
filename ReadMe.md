# New Project Skeleton

This is a [Brunch](http://brunch.io) project skeleton for elucidata apps (that
anyone can use) that includes: Backbone, Giraffe, Lo-Dash, and Bootstrap. For 
development using: CoffeeScript, Stylus, and Eco templates.

To create a new app using this skeleton:

    brunch new gh:elucidata/new-project MyNewApp

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


