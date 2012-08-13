// Generated by CoffeeScript 1.2.1-pre

window.onload = function() {
  var actors, c, r, wh, world, ww, x, _i;
  ww = wh = .2 * Math.min(window.innerWidth, window.innerHeight);
  actors = [];
  world = new World(ww, wh, 30, 0, 9);
  window.onkeydown = function(e) {
    if (e.keyCode === 68) {
      return world.toggleDebug();
    } else {
      return world.boxLayer.draw();
    }
  };
  world.makeWalls('#aaa');
  for (x = _i = 0; _i <= 8; x = ++_i) {
    r = new Rect(world, {
      x: x * 10,
      y: 50 + 3 * x,
      w: x + 1,
      h: x + 1,
      a: x + 1,
      fill: '#ddd'
    });
  }
  c = new Circle(world, {
    x: 4,
    y: 20,
    r: 2,
    fill: '#eee'
  });
  return world.render();
};
