pitft = require("pitft")
moment = require("moment-timezone")
fb = pitft("/dev/fb1", true)

fb.clear()

xMax = fb.size().width
yMax = fb.size().height
radius = yMax/2 - 10
RA = 180/Math.PI

drawDial = ->
    fb.color(1, 1, 1)
    fb.circle(xMax/2, yMax/2, radius)

    fb.color(0, 0, 0);
    for a in [0...360] by 6
        x0 = xMax/2 + Math.sin(a/RA) * (radius * 0.95)
        y0 = yMax/2 + Math.cos(a/RA) * (radius * 0.95)

        if (a % 30 == 0)
            x1 = xMax/2 + Math.sin(a/RA) * (radius * 0.85)
            y1 = yMax/2 + Math.cos(a/RA) * (radius * 0.85)
            fb.line(x0, y0, x1, y1, radius * 0.05)
        else
            x1 = xMax/2 + Math.sin(a/RA) * (radius * 0.90)
            y1 = yMax/2 + Math.cos(a/RA) * (radius * 0.90)
            fb.line(x0, y0, x1, y1, radius * 0.01)

hand = (_fb, x, y, angle, length, width) ->
    x0 = xMax/2 + Math.sin(angle/RA)
    y0 = yMax/2 - Math.cos(angle/RA)

    x1 = xMax/2 + Math.sin(angle/RA) * length
    y1 = yMax/2 - Math.cos(angle/RA) * length

    fb.line(x0, y0, x1, y1, width)

update = ->
    rotate = 180

    fb.color(1, 1, 1)
    fb.circle(xMax/2, yMax/2, radius * 0.85)
    try
        fb.image(xMax/2 - 75, yMax/2 + radius * 0.50 - 200, "examples/image.png")
    catch error
        console.log(error)

    fb.color(0, 0, 0)
    if process.env.TIMEZONE?
        rightNow = new moment().tz(process.env.TIMEZONE)
        fb.font("fantasy", 25)
        fb.text(xMax/2, yMax*0.7, process.env.TIMEZONE.split('/')[1], true, rotate)
    else
        rightNow = new moment()

    fb.color(0, 0, 0)
    hand(fb, 0, 0, (rightNow.seconds()/60 * 360) + rotate, radius * 0.8, radius * 0.015)
    hand(fb, 0, 0, (rightNow.minutes()/60 * 360) + rotate, radius * 0.8, radius * 0.05)
    hourProgression = (rightNow.hours() * 5) + (rightNow.minutes() / 12)
    hand(fb, 0, 0, (hourProgression/60 * 360) + rotate, radius * 0.6, radius * 0.05)

    fb.blit()

drawDial()
setInterval(update, 100)
