window.onload = ->
    ww = wh = .25 * Math.min window.innerWidth, window.innerHeight

    actors = []
    world = new World ww, wh, 30, 0, 9
    window.onkeydown = (e) ->
        if e.keyCode == 68  # d
            world.toggleDebug()

    world.makeWalls '#aaa'

    for x in [0..8]
        r = new Rect world,
            x: x * 10
            y: 50 + 3 * x
            w: x + 1
            h: x + 1
            a: x + 1
            fill: '#ddd'

    c = new Circle world,
        x: 50
        y: 50
        r: 2
        fill: '#eee'
        type: _MouseAttached

    window.world = world
    world.render()
