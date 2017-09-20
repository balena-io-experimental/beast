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

update = ->
  rightNow = moment()
  secondsAngle = rightNow.seconds()*6
  deltaX = Math.sin(radians(secondsAngle)) * totalX / 2
  deltaY = Math.cos(radians(secondsAngle)) * totalY / 2
  originX = totalX / 2
  originY = totalY / 2
  locationX = originX + deltaX
  locationY = originY + deltaY
  relativeOriginX = originX - (row * xResolution)
  relativeOriginY = originY - (column * yResolution)
  relativeLocationX = locationX - (row * xResolution)
  relativeLocationY = locationY - (column * yResolution)

  fb.clear()
  fb.color(1, 1, 1)
  fb.line(relativeOriginX, relativeOriginY, relativeLocationX, relativeLocationY, 10)
  fb.blit()

setInterval(update, 100)