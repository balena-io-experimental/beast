_ = require('lodash')
moment = require('moment')

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
  rightNow = moment().unix()
  secondsAngle = rightNow*6
  deltaX = Math.sin(secondsAngle) * totalX / 2
  deltaY = Math.cos(secondsAngle) * totalY / 2
  originX = totalX / 2
  originY = totalY / 2
  locationX = originX + deltaX
  locationY = originY + deltaY
  relativeOriginX = originX - (column * xResolution)
  relativeOriginY = originY - (row * yResolution)
  relativeLocationX = locationX - (column * xResolution)
  relativeLocationY = locationY - (column * yResolution)

  fb.color(1, 1, 1)
  fb.line(relativeLocationX, relativeLocationY, relativeOriginX, relativeOriginY, 10)
  fb.blit()

setInterval(update, 20)