Model = require 'framework/model'

class User extends Model
  @attr 'username', default:'Bob'
  @attr 'password'
  @attr 'usr', property:yes, default:'Sally'
  @attr 'pwd', property:yes, 

describe 'Framework', ->
  describe 'Model', ->
    describe 'Attribute Methods (ala jQuery)', ->
      beforeEach ->
        @model = new User()
      afterEach ->
        @model.dispose()

      it 'should create methods', ->
        expect(@model.username).to.exist
        expect(@model.password).to.exist

      it 'should return defaults, if they exist', ->
        expect(@model.username()).to.equal 'Bob'
        expect(@model.password()).to.be.undefined

      it 'should set attributes', ->
        expect(@model.username()).to.equal 'Bob'
        @model.username('Matt')
        expect(@model.username()).to.equal 'Matt'

        expect(@model.password()).to.be.undefined
        @model.password('pass')
        expect(@model.password()).to.equal 'pass'

      it 'should trigger change events', ->
        event_count= 0
        @model.on 'change', ->
          event_count += 1

        @model.username('Matt')
        expect(event_count).to.equal 1

        # No change, no event
        @model.username('Matt')
        expect(event_count).to.equal 1

        @model.username('Dan')
        expect(event_count).to.equal 2


    describe 'Attribute Properties', ->
      beforeEach ->
        @model = new User()
      afterEach ->
        @model.dispose()

      it 'should create properties', ->
        expect(@model.usr).to.exist
        expect(@model.pwd).to.be.undefined

      it 'should return defaults, if they exist', ->
        expect(@model.usr).to.equal 'Sally'
        expect(@model.pwd).to.be.undefined

      it 'should set attributes', ->
        expect(@model.usr).to.equal 'Sally'
        @model.usr = 'Matt'
        expect(@model.usr).to.equal 'Matt'

        expect(@model.pwd).to.be.undefined
        @model.pwd= 'pass'
        expect(@model.pwd).to.equal 'pass'

      it 'should trigger change events', ->
        event_count= 0
        @model.on 'change', ->
          event_count += 1

        @model.usr= 'Matt'
        expect(event_count).to.equal 1

        # No change, no event
        @model.usr = 'Matt'
        expect(event_count).to.equal 1

        @model.usr = 'Dan'
        expect(event_count).to.equal 2


# testUser= new User()

# $ ->
#   setTimeout (->
#     simplePerf 'Inline vs Curried Attribute Methods', { times:100000 },
#       'curried': ->
#         name= testUser.username()
#       'inline': ->
#         name= testUser.username2()
#   ), 1000


