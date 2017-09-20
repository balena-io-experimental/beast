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
xOffset = column * xResolution
yOffset = row * yResolution
centreX = totalX / 2
centreY = totalY / 2
originX = centreX - xOffset
originY = centreY - yOffset

drawHand = (length, width, angle) ->
  deltaX = Math.sin(radians(angle)) * length
  deltaY = Math.cos(radians(angle)) * length
  relativeLocationX = relativeOriginX + deltaX
  relativeLocationY = relativeOriginY + deltaY

  fb.line(originX, originY, originX + deltaX, originY + deltaY, width)
  fb.circle(originX, originY, width/2)
  fb.circle(originX + deltaX, originY + deltaY, width/2)

drawText = (text) ->
  relativeLocationX = centreX - xOffset
  relativeLocationY = centreY - yOffset
  fb.font("fantasy", totalY/6)
  fb.text(relativeLocationX, relativeLocationY, text, true)

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
  drawHand(smallestAxis / 4, smallestAxis / 40, hoursAngle)
  drawHand(smallestAxis / 2, smallestAxis / 40, minutesAngle)
  fb.color(0.5, 0, 0)
  drawHand(smallestAxis / 2, smallestAxis / 80, secondsAngle)
  fb.blit()

setInterval(update, 25)