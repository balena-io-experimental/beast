fb = require("pitft")("/dev/fb1");

fb.clear()

xMax = fb.size().width
yMax = fb.size().height

fb.color(1, 1, 1)
fb.font("fantasy", 36)
fb.text(xMax/3, yMax/2, process.env.RESIN_DEVICE_NAME_AT_INIT, true, 180)
fb.font("fantasy", 18)
fb.text(xMax*2/3, yMax/2, process.env.RESIN_DEVICE_UUID, true, 180)
