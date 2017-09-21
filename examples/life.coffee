Promise = require('bluebird')
moment = require('moment')
request = require('request-promise')
express = require('express')
app = express()

fb = require('pitft')('/dev/fb1', true)
fb.clear()
xResolution = fb.size().width
yResolution = fb.size().height

cols = parseInt(process.env.LIFE_COLUMNS_EACH ? '0')
rows = parseInt(process.env.LIFE_ROWS_EACH ? '0')
width = xResolution / cols
height = yResolution / rows

ecosystem = []
rendered = 0
minute = null

setup = ->
  rightNow = moment().minutes()
  if minute != rightNow
    minute = rightNow
    rendered = 0
    ecosystem = []
    ecosystem[0] = []
    for row in [0...rows]
      ecosystem[0][row] ?= []
      for col in [0...cols]
        ecosystem[0][row][col] = Math.random() < 0.5
  process.nextTick(calculate)

render = ->
  tick = moment().seconds()
  if tick > rendered
    fb.clear()
    rendered = tick
    console.log("Rendering #{tick}")
    fb.color(1, 1, 1)
    for col in [0...cols]
      for row in [0...rows]
        fb.rect(
          col * width, row * height, width, height,
          ecosystem[tick][row][col]
        )
    fb.blit()

calculate = ->
  if ecosystem.length < 60
    console.log("Calculating #{ecosystem.length}")
    tick = ecosystem.length
    for col in [0...cols]
      for row in [0...rows]
        sum = 0
        for colDelta in [0...3]
          for rowDelta in [0...3]
            if colDelta != 1 or rowDelta != 1
              focusCol = (col + colDelta - 1) %% cols
              focusRow = (row + rowDelta - 1) %% rows
              if ecosystem[tick-1][focusRow][focusCol]
                sum++
        ecosystem[tick] ?= []
        ecosystem[tick][row] ?= []
        if sum < 2
          ecosystem[tick][row][col] = false
        else if sum == 2
          ecosystem[tick][row][col] = ecosystem[tick-1][row][col]
        else if sum == 3
          ecosystem[tick][row][col] = true
        else
          ecosystem[tick][row][col] = false
    process.nextTick(calculate)

app.get('/', (inbound, outbound) ->
  requestedMinute = parseInt(inbound.query.minute, 10)
  requestedSecond = parseInt(inbound.query.second, 10)
  if requestedMinute == minute and ecosystem.length > requestedSecond
    if inbound.query.asset == 'row'
      colIterator = [0...cols]
      if inbound.query.position == 'first'
        rowIterator = [0]
      else
        rowIterator = [rows]
    else
      rowIterator = [0...rows]
      if inbound.query.position == 'first'
        colIterator = [0]
      else
        colIterator = [cols]
    outboundArray = []
    for focusCol in colIterator
      for focusRow in rowIterator
        outboundArray.push(ecosystem[requestedSecond][focusRow][focusCol])
    outbound.send(JSON.stringify(outboundArray))
  else
    outbound.send(404)
)
server = app.listen(80)
setInterval(setup, 330)
setInterval(render, 50)
setup()
