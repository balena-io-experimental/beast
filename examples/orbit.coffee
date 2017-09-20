_ = require('lodash')
moment = require('moment')
radians = require('degrees-radians')

fb = require("pitft")("/dev/fb1", true)
fb.clear()
xResolution = fb.size().width
yResolution = fb.size().height

snake = JSON.parse(process.env.RASTER_SNAKE)
index = _.indexOf(snake, process.env.RESIN_DEVICE_UUID)
columns = parseInt(process.env.RASTER_COLUMNS, 10)
rows = snake.length / columns
column = index % columns
row = Math.floor(index / columns)

totalX = xResolution * columns
totalY = yResolution * rows
smallestAxis = Math.min(totalX, totalY)

drawHand = (originX, originY, length, angle) ->
  deltaX = Math.sin(radians(angle)) * length
  deltaY = Math.cos(radians(angle)) * length
  locationX = originX + deltaX
  locationY = originY + deltaY
  relativeOriginX = originX - (column * xResolution)
  relativeOriginY = originY - (row * yResolution)
  relativeLocationX = locationX - (column * xResolution)
  relativeLocationY = locationY - (row * yResolution)

  fb.color(1, 1, 1)
  fb.line(
    xResolution - relativeOriginX,
    yResolution - relativeOriginY,
    xResolution - relativeLocationX,
    yResolution - relativeLocationY,
    10
  )
  fb.blit()
  [locationX, locationY]

update = ->
  rightNow = moment().unix()
  secondsAngle = (rightNow)*6
  minutesAngle = (rightNow/60)*6
  hoursAngle = (rightNow/3600)*30
  fb.clear()
  end = drawHand(totalX / 2, totalY / 2, smallestAxis / 2, secondsAngle)
  end = drawHand(end[0], end[1], smallestAxis / 4, secondsAngle)
  end = drawHand(end[0], end[1], smallestAxis / 8, secondsAngle)

setInterval(update, 100)