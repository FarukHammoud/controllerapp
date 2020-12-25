from controller import Controller

c = Controller('a1b2c3')

def p(x,y):
    print(x,y)

c.mobile.onTap = p



