fb = require("pitft")("/dev/fb1", true)

fb.clear()

xMax = fb.size().width
yMax = fb.size().height

fb.color(1, 1, 1)
fb.font("fantasy", 40)
fb.text(xMax/2, yMax*2/3, process.env.RESIN_DEVICE_NAME_AT_INIT, true, 180)
fb.font("fantasy", 20)
fb.text(xMax/2, yMax*1/3, process.env.RESIN_DEVICE_UUID, true, 180)
fb.blit()
