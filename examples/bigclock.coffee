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
xOffset = column * xResolution
yOffset = row * yResolution
centreX = totalX / 2
centreY = totalY / 2
originX = centreX - xOffset
originY = centreY - yOffset

drawHand = (length, width, angle) ->
  deltaX = - Math.sin(radians(-angle)) * totalX * length * 0.5
  deltaY = - Math.cos(radians(-angle)) * totalY * length * 0.5
  relativeLocationX = originX + deltaX
  relativeLocationY = originY + deltaY

  lineWidth = width * Math.min(totalY, totalX)
  fb.line(originX, originY, originX + deltaX, originY + deltaY, lineWidth)
  fb.circle(originX, originY, lineWidth / 2)
  fb.circle(originX + deltaX, originY + deltaY, lineWidth / 2)

drawText = (text) ->
  fb.font("fantasy", Math.min(totalX, totalY/6))
  fb.text(originX, originY, text, true)

update = ->
  rightNow = moment()
  fb.clear()
  secondsAngle = rightNow.seconds() * 6
  minutesAngle = rightNow.minutes() * 6
  hourProgression = (rightNow.hours() * 5) + (rightNow.minutes() / 12)
  hoursAngle = hourProgression * 6
  fb.color(0.5, 0.5, 0.5)
  drawText(rightNow.format('LTS'))
  fb.color(1, 1, 1)
  drawHand(0.5, 0.03, hoursAngle)
  drawHand(0.9, 0.03, minutesAngle)
  fb.color(0.5, 0, 0)
  drawHand(0.9, 0.02, secondsAngle)
  fb.blit()

setInterval(update, 25)