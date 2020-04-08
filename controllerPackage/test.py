from controller import Controller

c = Controller('fabric')

def onRotation(x,y,ang):
    print(c.mobile.getAccelerometer())

c.mobile.onRotation = onRotation



