_Vec2 = Box2D.Common.Math.b2Vec2
_BodyDef = Box2D.Dynamics.b2BodyDef
_Body = Box2D.Dynamics.b2Body
_FixtureDef = Box2D.Dynamics.b2FixtureDef
_Fixture = Box2D.Dynamics.b2Fixture
_World = Box2D.Dynamics.b2World
_MassData = Box2D.Collision.Shapes.b2MassData
_PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
_CircleShape = Box2D.Collision.Shapes.b2CircleShape
_DebugDraw = Box2D.Dynamics.b2DebugDraw
_DistanceJointDef = Box2D.Dynamics.Joints.b2DistanceJointDef
_MouseJointDef = Box2D.Dynamics.Joints.b2MouseJointDef
_Dynamic = _Body.b2_dynamicBody
_Kinetic = _Body.b2_kineticBody
_Static = _Body.b2_StaticBody

class World
    constructor: (@ww, @wh, @scaleFactor=30, @gravity_x=0, @gravity_y=0, @angularDamping=0, @linearDamping=0, @restitution=.1, @density=2, @friction=.9, @velocity=300, @position=200, @debug=false) ->
        @world = new _World(new _Vec2(@gravity_x, @gravity_y), true)
        @stage = new Kinetic.Stage
            container: "container"
            width: ww
            height: wh
        @boxLayer = new Kinetic.Layer()
        @debugLayer = new Kinetic.Layer()
        @stage.add @boxLayer
        @stage.add @debugLayer
        @actors = []
        @makeDrawer()
        @lastTime = new Date().getTime()

    makeBody: (x, y, a=0, type=_Dynamic, angularDamping=null, linearDamping=null) ->
        bodyDef = new _BodyDef()
        bodyDef.type = type
        bodyDef.position.x = x / @scaleFactor
        bodyDef.position.y = y / @scaleFactor
        bodyDef.angle = a
        bodyDef.angularDamping = if angularDamping != null then angularDamping else @angularDamping
        bodyDef.linearDamping = if linearDamping != null then linearDamping else @linearDamping
        @world.CreateBody(bodyDef)

    makeFixture: (body, shape, restitution=null, density=null, friction=null) ->
        fixtureDef = new _FixtureDef()
        fixtureDef.restitution = if restitution != null then restitution else @restitution
        fixtureDef.density = if density != null then density else @density
        fixtureDef.friction = if friction != null then friction else @friction
        fixtureDef.shape = shape
        body.CreateFixture fixtureDef

    makeDrawer: ->
        drawer = new _DebugDraw()
        drawer.SetSprite @debugLayer.context
        drawer.SetDrawScale @scaleFactor
        drawer.SetFillAlpha .5
        drawer.SetLineThickness 1.0
        drawer.SetFlags _DebugDraw.e_shapeBit | _DebugDraw.e_jointBit
        @world.SetDebugDraw drawer

    render: ->
        animloop = =>
            (window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame) animloop
            @_render @drawer   
        animloop()

    _render: ->
        time = new Date().getTime()
        delta = (time - @lastTime) / 1000
        @lastTime = time
        @world.Step delta, delta * @velocity, delta * @position
        if @debug
            @world.DrawDebugData()
        for actor in @actors
            pos = actor.body.GetPosition()
            actor.el.setX pos.x * @scaleFactor
            actor.el.setY pos.y * @scaleFactor
            actor.el.setRotation actor.body.GetAngle()

        @boxLayer.draw()
        @world.ClearForces()
        

class Box2d
    constructor: (@world) ->

    
class Shape extends Box2d

    constructor: (world, c) ->
        super world
        
        c.x = @xp c.x
        c.y = @yp c.y
        if not c.a
            c.a = 0
        if c.r
            @w = @h = @r = c.radius = @xp c.r
        else if c.w
            @w = c.width = @xp c.w
            @h = c.height = @yp c.h
            c.offset = x: c.width / 2, y: c.height / 2

        c.rotation = c.a
        if c.shadow is not false
            c.shadow =
                color: "black"
                blur: 10
                offset: [5, 5]
                alpha: 0.6
        @el = new @type c
        @body = @world.makeBody c.x, c.y, c.a
        @world.makeFixture @body, @shape()

        @world.boxLayer.add @el
        @world.actors.push @

    b2d: (v) ->
        v / @world.scaleFactor
        
    xp: (x) ->
        x * @world.ww / 100
        
    yp: (y) ->
        y * @world.wh / 100
          
    add: ->


class Rect extends Shape
    constructor: (world, config) ->
        @type = Kinetic.Rect
        super(world, config)

    shape: ->
        shape = new _PolygonShape()
        shape.SetAsBox(@b2d(@w) / 2, @b2d(@h) / 2)
        shape

class Circle extends Shape
    constructor: (world, config) ->
        @type = Kinetic.Circle
        super(world, config)

    shape: ->
        new _CircleShape(@b2d(@r))
