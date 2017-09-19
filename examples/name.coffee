fb = require("pitft")("/dev/fb1");

fb.clear()

xMax = fb.size.width()
yMax = fb.size.height()

fb.color(1, 1, 1)
fb.font("fantasy", 12)
fb.text(xMax/2, yMax/2, process.env.RESIN_DEVICE_NAME_AT_INIT, true, 0)
