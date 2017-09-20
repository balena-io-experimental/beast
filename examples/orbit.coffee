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
  deltaY = 0 - Math.cos(radians(angle)) * length
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
  fb.circle(
    xResolution - relativeOriginX,
    yResolution - relativeOriginY,
    5
  )
  fb.circle(
    xResolution - relativeLocationX,
    yResolution - relativeLocationY,
    5
  )
  [locationX, locationY]

drawText = (text) ->
  locationX = totalX / 2
  locationY = totalY / 2
  relativeLocationX = locationX - (column * xResolution)
  relativeLocationY = locationY - (row * yResolution)
  fb.color(1, 1, 1)
  fb.font("fantasy", 40)
  fb.text(xResolution/2, yResolution/2, text, true, 180)

update = ->
  rightNow = moment()
  secondsAngle = rightNow.seconds() * 6
  minutesAngle = rightNow.minutes() * 6
  hourProgression = (rightNow.hours() * 5) + (rightNow.minutes() / 12)
  hoursAngle = hourProgression*6
  fb.clear()
  end = drawHand(totalX / 2, totalY / 2, smallestAxis / 4, hoursAngle)
  end = drawHand(end[0], end[1], smallestAxis / 8, minutesAngle)
  end = drawHand(end[0], end[1], smallestAxis / 16, secondsAngle)
  drawText(rightNow.format('LTS'))
  fb.blit()

setInterval(update, 100)