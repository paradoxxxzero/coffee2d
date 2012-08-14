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
_RevoluteJointDef = Box2D.Dynamics.Joints.b2RevoluteJointDef
_MouseJointDef = Box2D.Dynamics.Joints.b2MouseJointDef
_Dynamic = _Body.b2_dynamicBody
_Kinematic = _Body.b2_kinematicBody
_Static = _Body.b2_staticBody
_MouseAttached = 99
WORLD = null

ON = (w) ->
    WORLD = w

class World
    constructor: (@ww, @wh, @scaleFactor=30, @gravity_x=0, @gravity_y=0, @angularDamping=0, @linearDamping=0, @restitution=.1, @density=2, @friction=.9, @velocity=300, @position=200, @frequencyHz=2, @dampingRatio=.2, @debug=false) ->
        @world = new _World(new _Vec2(@gravity_x, @gravity_y), true)
        @mouse =
            x: 0
            y: 0
        @mouseJoints = []

        window.document.body.addEventListener 'mousemove', ((e) =>
            @mouse.x = e.clientX
            @mouse.y = e.clientY
            for joint in @mouseJoints
                joint.SetTarget new _Vec2 @mouse.x / @scaleFactor, @mouse.y / @scaleFactor
        ), false

        window.addEventListener 'keydown', ((e) =>
            if e.keyCode == 68  # d
                @toggleDebug()
        ), false
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

    makeJoint: (bodyA, bodyB, type=_DistanceJointDef, length=null, anchorA, anchorB, frequencyHz=null, dampingRatio=null) ->
        jointDef = new type()
        jointDef.bodyA = bodyA.body
        jointDef.bodyB = bodyB.body
        jointDef.frequencyHz = if frequencyHz != null then frequencyHz else @frequencyHz
        jointDef.dampingRatio = if dampingRatio != null then dampingRatio else @dampingRatio
        jointDef.localAnchorA = if anchorA != null then anchorA else new _Vec2(0, 0)
        jointDef.localAnchorB = if anchorB != null then anchorB else new _Vec2(0, 0)
        jointDef.length = if length != null then length else 0
        @world.CreateJoint(jointDef)

    makeMouseJoint: (target) ->
        jointDef = new _MouseJointDef();
        jointDef.bodyA = @world.GetGroundBody()
        jointDef.bodyB = target.body
        jointDef.frequencyHz = 100
        jointDef.target = target.body.GetPosition()
        jointDef.collideConnected = true
        jointDef.maxForce = 300 * target.body.GetMass()
        @mouseJoints.push @world.CreateJoint(jointDef)

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

    makeWalls: (fill='#999', thickness=4, top=true, bottom=true, right=true, left=true) ->
        wall = new _PolygonShape()
        wallBd = new _BodyDef()
        bw = @ww / @scaleFactor
        bh = @wh / @scaleFactor
        
        if left
            new Rect
                x: 0
                y: 50
                w: thickness
                h: 100
                type: _Static
                fill: fill
                 
        if right
            new Rect
                x: 100
                y: 50
                w: thickness
                h: 100
                type: _Static
                fill: fill

        if top
            new Rect
                x: 50
                y: 0
                w: 100
                h: thickness
                type: _Static
                fill: fill

        if bottom
            new Rect
                x: 50
                y: 100
                w: 100
                h: thickness
                type: _Static
                fill: fill

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
        
    setDebug: (state) ->
        @debug = state
        if not @debug
            @debugLayer.clear()
            
    toggleDebug: ->
        @setDebug !@debug

class Box2d
    constructor: (@world) ->
        if not @world and WORLD
            @world = WORLD

    b2d: (v) ->
        v / @world.scaleFactor

    xp: (x) ->
        x * @world.ww / 100

    yp: (y) ->
        y * @world.wh / 100

class Joint extends Box2d
    constructor: (shapeA, shapeB, c, world) ->
        super world
        if c.anchorA != undefined
            c.anchorA = new _Vec2 @b2d(@xp(c.anchorA.x)), @b2d(@yp(c.anchorA.y))
        else
            c.anchorA = null
        if c.anchorB != undefined
            c.anchorB = new _Vec2 @b2d(@xp(c.anchorB.x)), @b2d(@yp(c.anchorB.y))
        else
            c.anchorB = null

        if c.length != undefined
            c.length = @b2d(@yp(c.length))
            console.log c.length
        @world.makeJoint shapeA, shapeB, @type, c.length, c.anchorA, c.anchorB, c.frequencyHz, c.dampingRatio

class DistanceJoint extends Joint
    constructor: (shapeA, shapeB, config, world=null) ->
        @type = _DistanceJointDef
        super(shapeA, shapeB, config, world)

class RevoluteJoint extends Joint
    constructor: (shapeA, shapeB, config, world=null) ->
        @type = _RevoluteJointDef
        super(shapeA, shapeB, config, world)


class Shape extends Box2d
    constructor: (c, world) ->
        super world
        
        c.x = @xp c.x
        c.y = @yp c.y
        if not c.a
            c.a = 0
        if c.type == _MouseAttached
            mouseAttached = true
            c.type = _Dynamic
            
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
        @body = @world.makeBody c.x, c.y, c.a, c.type
        @world.makeFixture @body, @shape()
        if mouseAttached
            @world.makeMouseJoint @

        @world.boxLayer.add @el
        @world.actors.push @


class Rect extends Shape
    constructor: (config, world=null) ->
        @type = Kinetic.Rect
        super(config, world)

    shape: ->
        shape = new _PolygonShape()
        shape.SetAsBox(@b2d(@w) / 2, @b2d(@h) / 2)
        shape

class Circle extends Shape
    constructor: (config, world=null) ->
        @type = Kinetic.Circle
        super(config, world)

    shape: ->
        new _CircleShape(@b2d(@r))
