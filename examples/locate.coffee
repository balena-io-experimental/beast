_ = require('lodash')

fb = require("pitft")("/dev/fb1", true)
fb.clear()
xMax = fb.size().width
yMax = fb.size().height

index = _.indexOf(process.env.RASTER_SNAKE, process.env.RESIN_DEVICE_UUID)
column = index % process.env.RASTER_COLUMNS
row = Math.floor(index / process.env.RASTER_COLUMNS)

update = ->
  fb.color(1, 1, 1)
  fb.font("fantasy", 40)
  fb.text(xMax/2, yMax/2, "(#{column}, #{row})", true, 180)

setInterval(update, 1000)