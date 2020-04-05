from controller.controller import Controller
from time import sleep

c = Controller('a1b2c3')
c.connect()
print('luckly..')
sleep(3)
c.disconnect()
