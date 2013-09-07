tests = [
  './models/version-test'
]

console.log 'module', module
console.log 'arguments', arguments

for test in tests
  require test
