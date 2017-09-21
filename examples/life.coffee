fb = require('pitft')('/dev/fb1', true)
fb.clear()
xResolution = fb.size().width
yResolution = fb.size().height

cols = parseInt(process.env.LIFE_COLUMNS_EACH ? '0')
rows = parseInt(process.env.LIFE_ROWS_EACH ? '0')
width = xResolution / cols
height = yResolution / rows

ecosystem = []
for row in [0...rows]
  ecosystem[row] ?= []
  for col in [0...cols]
    ecosystem[row][col] ?= [Math.random() < 0.5]

render = ->
  fb.clear()
  fb.color(1, 1, 1)
  for col in [0...cols]
    for row in [0...rows]
      fb.rect(
        col * width, row * height, width, height,
        ecosystem[row][col][ecosystem[row][col].length - 1]
      )
  fb.blit()

calculate = ->
  for col in [0...cols]
    for row in [0...rows]
      tick = ecosystem[row][col].length
      sum = 0
      for colDelta in [-1...1]
        for rowDelta in [-1...1]
          if colDelta != 0 or rowDelta != 0
            focusCol = (col + colDelta) %% cols
            focusRow = (row + rowDelta) %% rows
            if ecosystem[focusRow][focusCol][tick-1]
              sum++
      if sum == 3
        console.log(tick, sum)
      if sum < 2
        ecosystem[row][col][tick] = false
      else if sum == 2
        ecosystem[row][col][tick] = ecosystem[row][col][tick-1]
      else if sum == 3
        ecosystem[row][col][tick] = true
      else
        ecosystem[row][col][tick] = false

setInterval(render, 20)
setInterval(calculate, 1000)