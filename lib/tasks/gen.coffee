
option '-p', '--path [DIR]', '(gen) Where to place the generated file'

task 'gen', "Runs scaffold generator", (options)->
  if options.arguments.length < 3 
    invoke 'gen:ls'
    echo "Requires type and name params:"
    echo "   cake gen model user"
    process.exit(1)

  name= options.arguments.pop()
  type= options.arguments.pop()
  opts= if options.path? then "-p #{options.path}" else ""

  cmd= "scaffolt #{type} #{name} -g #{PATH.GEN} #{opts}"
  echo cmd
  exec(cmd)
  process.exit(0)


task 'gen:ls', "List known generators", (options)->
  cmd= "scaffolt -g #{PATH.GEN} --list"
  # exec_loud(cmd)
  exec(cmd)
