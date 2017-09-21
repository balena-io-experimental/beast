Promise = require('bluebird')
moment = require('moment')

fb = require('pitft')('/dev/fb1', true)
fb.clear()
xResolution = fb.size().width
yResolution = fb.size().height

cols = parseInt(process.env.LIFE_COLUMNS_EACH ? '0')
rows = parseInt(process.env.LIFE_ROWS_EACH ? '0')
width = xResolution / cols
height = yResolution / rows

ecosystem = []

setup = (force = false) ->
  if force or moment().seconds() == 0
    ecosystem = []
    for row in [0...rows]
      ecosystem[row] ?= []
      for col in [0...cols]
        ecosystem[row][col] ?= [Math.random() < 0.5]

render = ->
  fb.clear()
  second = moment().seconds()
  if second != 0
    console.log("Rendering #{second}")
    fb.color(1, 1, 1)
    for col in [0...cols]
      for row in [0...rows]
        fb.rect(
          col * width, row * height, width, height,
          ecosystem[row][col][second]
        )
    fb.blit()

calculate = ->
  if ecosystem[0][0].length < 60
    console.log("Calculating #{ecosystem[0][0].length}")
    for col in [0...cols]
      for row in [0...rows]
        tick = ecosystem[row][col].length
        sum = 0
        for colDelta in [0...3]
          for rowDelta in [0...3]
            if colDelta != 1 or rowDelta != 1
              focusCol = (col + colDelta - 1) %% cols
              focusRow = (row + rowDelta - 1) %% rows
              if ecosystem[focusRow][focusCol][tick-1]
                sum++
        if sum < 2
          ecosystem[row][col].push(false)
        else if sum == 2
          ecosystem[row][col].push(ecosystem[row][col][tick-1])
        else if sum == 3
          ecosystem[row][col].push(true)
        else
          ecosystem[row][col].push(false)
    process.nextTick(calculate)

setup(true)
setInterval(setup, 100)
setInterval(render, 20)
calculate()