Version = require('models/version')

describe 'Version', ->
  beforeEach ->
    @model = Version

  it 'should exist', ->
    expect(@model).to.exist
