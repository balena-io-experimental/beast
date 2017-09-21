fb = require('pitft')('/dev/fb1', true)
fb.clear()
xResolution = fb.size().width
yResolution = fb.size().height

columns = parseInt(process.env.LIFE_COLUMNS_EACH ? '0')
rows = parseInt(process.env.LIFE_ROWS_EACH ? '0')
width = xResolution / columns
height = yResolution / rows

ecosystem = []
for row in [0...rows]
  ecosystem[row] ?= []
  for column in [0...columns]
    ecosystem[row][column] ?= [Math.random() < 0.5]
console.log(ecosystem)

render = ->
  fb.clear()
  fb.color(1, 1, 1)
  for column in [0...columns]
    for row in [0...rows]
      fb.rect(
        column * width, row * height,
        width, height,
        ecosystem[row][column]
      )
  fb.blit()

calculate = ->
  for column in [0...columns]
    for row in [0...rows]


setInterval(render, 1000)