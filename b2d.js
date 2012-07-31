// Generated by CoffeeScript 1.2.1-pre
var Box2d, Circle, Rect, Shape, World, _Body, _BodyDef, _CircleShape, _DebugDraw, _DistanceJointDef, _Dynamic, _Fixture, _FixtureDef, _Kinetic, _MassData, _MouseJointDef, _PolygonShape, _Static, _Vec2, _World,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

_Vec2 = Box2D.Common.Math.b2Vec2;

_BodyDef = Box2D.Dynamics.b2BodyDef;

_Body = Box2D.Dynamics.b2Body;

_FixtureDef = Box2D.Dynamics.b2FixtureDef;

_Fixture = Box2D.Dynamics.b2Fixture;

_World = Box2D.Dynamics.b2World;

_MassData = Box2D.Collision.Shapes.b2MassData;

_PolygonShape = Box2D.Collision.Shapes.b2PolygonShape;

_CircleShape = Box2D.Collision.Shapes.b2CircleShape;

_DebugDraw = Box2D.Dynamics.b2DebugDraw;

_DistanceJointDef = Box2D.Dynamics.Joints.b2DistanceJointDef;

_MouseJointDef = Box2D.Dynamics.Joints.b2MouseJointDef;

_Dynamic = _Body.b2_dynamicBody;

_Kinetic = _Body.b2_kineticBody;

_Static = _Body.b2_StaticBody;

World = (function() {

  World.name = 'World';

  function World(ww, wh, scaleFactor, gravity_x, gravity_y, angularDamping, linearDamping, restitution, density, friction, velocity, position, debug) {
    this.ww = ww;
    this.wh = wh;
    this.scaleFactor = scaleFactor != null ? scaleFactor : 30;
    this.gravity_x = gravity_x != null ? gravity_x : 0;
    this.gravity_y = gravity_y != null ? gravity_y : 0;
    this.angularDamping = angularDamping != null ? angularDamping : 0;
    this.linearDamping = linearDamping != null ? linearDamping : 0;
    this.restitution = restitution != null ? restitution : .1;
    this.density = density != null ? density : 2;
    this.friction = friction != null ? friction : .9;
    this.velocity = velocity != null ? velocity : 300;
    this.position = position != null ? position : 200;
    this.debug = debug != null ? debug : false;
    this.world = new _World(new _Vec2(this.gravity_x, this.gravity_y), true);
    this.stage = new Kinetic.Stage({
      container: "container",
      width: ww,
      height: wh
    });
    this.boxLayer = new Kinetic.Layer();
    this.debugLayer = new Kinetic.Layer();
    this.stage.add(this.boxLayer);
    this.stage.add(this.debugLayer);
    this.actors = [];
    this.makeDrawer();
    this.lastTime = new Date().getTime();
  }

  World.prototype.makeBody = function(x, y, a, type, angularDamping, linearDamping) {
    var bodyDef;
    if (a == null) a = 0;
    if (type == null) type = _Dynamic;
    if (angularDamping == null) angularDamping = null;
    if (linearDamping == null) linearDamping = null;
    bodyDef = new _BodyDef();
    bodyDef.type = type;
    bodyDef.position.x = x / this.scaleFactor;
    bodyDef.position.y = y / this.scaleFactor;
    bodyDef.angle = a;
    bodyDef.angularDamping = angularDamping !== null ? angularDamping : this.angularDamping;
    bodyDef.linearDamping = linearDamping !== null ? linearDamping : this.linearDamping;
    return this.world.CreateBody(bodyDef);
  };

  World.prototype.makeFixture = function(body, shape, restitution, density, friction) {
    var fixtureDef;
    if (restitution == null) restitution = null;
    if (density == null) density = null;
    if (friction == null) friction = null;
    fixtureDef = new _FixtureDef();
    fixtureDef.restitution = restitution !== null ? restitution : this.restitution;
    fixtureDef.density = density !== null ? density : this.density;
    fixtureDef.friction = friction !== null ? friction : this.friction;
    fixtureDef.shape = shape;
    return body.CreateFixture(fixtureDef);
  };

  World.prototype.makeDrawer = function() {
    var drawer;
    drawer = new _DebugDraw();
    drawer.SetSprite(this.debugLayer.context);
    drawer.SetDrawScale(this.scaleFactor);
    drawer.SetFillAlpha(.5);
    drawer.SetLineThickness(1.0);
    drawer.SetFlags(_DebugDraw.e_shapeBit | _DebugDraw.e_jointBit);
    return this.world.SetDebugDraw(drawer);
  };

  World.prototype.render = function() {
    var animloop,
      _this = this;
    animloop = function() {
      (window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame)(animloop);
      return _this._render(_this.drawer);
    };
    return animloop();
  };

  World.prototype._render = function() {
    var actor, delta, pos, time, _i, _len, _ref;
    time = new Date().getTime();
    delta = (time - this.lastTime) / 1000;
    this.lastTime = time;
    this.world.Step(delta, delta * this.velocity, delta * this.position);
    if (this.debug) this.world.DrawDebugData();
    _ref = this.actors;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      actor = _ref[_i];
      pos = actor.body.GetPosition();
      actor.el.setX(pos.x * this.scaleFactor);
      actor.el.setY(pos.y * this.scaleFactor);
      actor.el.setRotation(actor.body.GetAngle());
    }
    this.boxLayer.draw();
    return this.world.ClearForces();
  };

  return World;

})();

Box2d = (function() {

  Box2d.name = 'Box2d';

  function Box2d(world) {
    this.world = world;
  }

  return Box2d;

})();

Shape = (function(_super) {

  __extends(Shape, _super);

  Shape.name = 'Shape';

  function Shape(world, c) {
    Shape.__super__.constructor.call(this, world);
    c.x = this.xp(c.x);
    c.y = this.yp(c.y);
    if (!c.a) c.a = 0;
    if (c.r) {
      this.w = this.h = this.r = c.radius = this.xp(c.r);
    } else if (c.w) {
      this.w = c.width = this.xp(c.w);
      this.h = c.height = this.yp(c.h);
      c.offset = {
        x: c.width / 2,
        y: c.height / 2
      };
    }
    c.rotation = c.a;
    if (c.shadow === !false) {
      c.shadow = {
        color: "black",
        blur: 10,
        offset: [5, 5],
        alpha: 0.6
      };
    }
    this.el = new this.type(c);
    this.body = this.world.makeBody(c.x, c.y, c.a);
    this.world.makeFixture(this.body, this.shape());
    this.world.boxLayer.add(this.el);
    this.world.actors.push(this);
  }

  Shape.prototype.b2d = function(v) {
    return v / this.world.scaleFactor;
  };

  Shape.prototype.xp = function(x) {
    return x * this.world.ww / 100;
  };

  Shape.prototype.yp = function(y) {
    return y * this.world.wh / 100;
  };

  Shape.prototype.add = function() {};

  return Shape;

})(Box2d);

Rect = (function(_super) {

  __extends(Rect, _super);

  Rect.name = 'Rect';

  function Rect(world, config) {
    this.type = Kinetic.Rect;
    Rect.__super__.constructor.call(this, world, config);
  }

  Rect.prototype.shape = function() {
    var shape;
    shape = new _PolygonShape();
    shape.SetAsBox(this.b2d(this.w) / 2, this.b2d(this.h) / 2);
    return shape;
  };

  return Rect;

})(Shape);

Circle = (function(_super) {

  __extends(Circle, _super);

  Circle.name = 'Circle';

  function Circle(world, config) {
    this.type = Kinetic.Circle;
    Circle.__super__.constructor.call(this, world, config);
  }

  Circle.prototype.shape = function() {
    return new _CircleShape(this.b2d(this.r));
  };

  return Circle;

})(Shape);
