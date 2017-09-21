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

render = ->
  fb.clear()
  fb.color(1, 1, 1)
  for column in [0...columns]
    for row in [0...rows]
      fb.rect(
        column * width, row * height, width, height,
        ecosystem[row][column][ecosystem[row][column].length - 1]
      )
  fb.blit()

calculate = ->
  for column in [0...columns]
    for row in [0...rows]
      tick = ecosystem[row][column].length
      sum = 0
      for deltaX in [-1...1]
        for deltaY in [-1...1]
          if deltaX != 0 or deltaY != 0
            focusColumn = (column + deltaX) %% columns
            focusRow = (row + deltaY) %% rows
            if ecosystem[focusRow][focusColumn][tick-1]
              sum += 1
      if sum < 2
        ecosystem[row][column][tick] = false
      else if sum = 2
        ecosystem[row][column][tick] = ecosystem[row][column][tick-1]
      else if sum = 3
        ecosystem[row][column][tick] = true
      else
        ecosystem[row][column][tick] = false

setInterval(render, 20)
setInterval(calculate, 1000)