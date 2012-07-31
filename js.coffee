window.onload = ->
    # ww = window.innerWidth
    # wh = window.innerHeight
    ww = wh = Math.min window.innerWidth, window.innerHeight

    actors = []
    world = new World ww, wh, 30, 0, 9
    
    makeWall = () ->
        wall = new _PolygonShape()
        wallBd = new _BodyDef()
        bw = ww / 30
        bh = wh / 30
        
        # Left
        wallBd.position.Set .25, 0
        wall.SetAsBox .25, bh
        wallLeft = world.world.CreateBody(wallBd)
        wallLeft.CreateFixture2 wall

        # Right
        wallBd.position.Set bw - .25, 0
        wallRight = world.world.CreateBody(wallBd)
        wallRight.CreateFixture2 wall

        # Top
        wallBd.position.Set 0, .25
        wall.SetAsBox bw, .25
        _wallTop = world.world.CreateBody(wallBd)
        _wallTop.CreateFixture2 wall

        # Bottom
        wallBd.position.Set 0, bh - .25
        _wallBottom = world.world.CreateBody(wallBd)
        _wallBottom.CreateFixture2 wall

   
    window.onkeydown = (e) ->
        if e.keyCode == 68  # d
            world.debug = not world.debug
            if not world.debug
                world.debugLayer.clear()
        else
            world.boxLayer.draw()

    makeWall()

    for x in [0..8]
        r = new Rect world,
            x: x * 10
            y: 50 + 3 * x
            w: x + 1
            h: x + 1
            a: (x + 1)
            fill: '#ddd'

    c = new Circle world,
        x: 4
        y: 20
        r: 2
        fill: '#eee'


    world.render()
