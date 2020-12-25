from controller import Controller
from processing_py import *

app = App(600,400)
c = Controller('fabric') # You do need to change the code in the app

while True: 
    angle = c.mobile.getAngle()
    Size = c.mobile.getSize()
    app.background(0)
    app.fill(255,0,0)
    app.pushMatrix()
    app.translate(300, 200)
    app.rotate(angle)
    app.fill(255, 0, 0)
    app.noStroke()
    app.rect( -Size/2, -Size/2, Size, Size)
    app.popMatrix()
    app.redraw()






