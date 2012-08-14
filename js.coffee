window.onload = ->
    ww = wh = Math.min window.innerWidth, window.innerHeight

    actors = []
    world = new World ww, wh, 30, 0, 9
    ON world
    fill = '#ddf'
    thickness = 2

    new Rect
        x: 10
        y: 35
        w: 20
        h: thickness
        type: _Static
        fill: fill

    for x in [0..5]
        new Rect
            x: 20 + x * 10
            y: 35 + x * 10 + 5
            w: thickness
            h: 10
            type: _Static
            fill: fill
        new Rect
            x: 20 + x * 10 + if x != 5 then 5 else 15
            y: 35 + (x + 1) * 10
            w: if x != 5 then 10 else 30
            h: thickness
            type: _Static
            fill: fill

    c = new Circle
        x: 50
        y: 50
        r: 2
        fill: '#eee'
        type: _MouseAttached
        
    head = new Circle
        x: 10
        y: 10
        r: 3
        fill: '#ddf'

    torso = new Rect
        x: 10
        y: 13
        w: 3
        h: 6
        fill: '#ddd'

    arm1 = new Rect
        x: 13
        y: 14
        w: 6
        h: 2
        fill: '#dfd'

    arm2 = new Rect
        x: 13
        y: 14
        w: 6
        h: 2
        fill: '#ded'

    leg1 = new Rect
        x: 10
        y: 17
        w: 2
        h: 6
        fill: '#fdd'

    leg2 = new Rect
        x: 10
        y: 17
        w: 2
        h: 6
        fill: '#edd'

    new DistanceJoint head, torso,
        anchorB:
            x: 0
            y: -2.5
        length: 4
        frequencyHz: 0
        dampingRatio: 1

    new RevoluteJoint arm1, torso,
        anchorA:
            x: -2.5
            y: 0
        anchorB:
            x: 0
            y: -2.5

    new RevoluteJoint arm2, torso,
        anchorA:
            x: -2.5
            y: 0
        anchorB:
            x: 0
            y: -2.5

    new RevoluteJoint leg1, torso,
        anchorA:
            x: 0
            y: -2.5
        anchorB:
            x: 0
            y: 2.5

    new RevoluteJoint leg2, torso,
        anchorA:
            x: 0
            y: -2.5
        anchorB:
            x: 0
            y: 2.5

    new Rect
        x: 3
        y: 29
        w: 6
        h: 10
        type: _Kinematic
        fill: '#eef'

    world.makeWalls '#efe'
    world.render()
