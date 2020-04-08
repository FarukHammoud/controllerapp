from controller import Controller

c = Controller('fabric')

def onRotation(x,y,ang):
    print(c.mobile.getAngle())

c.mobile.onRotation = onRotation



