import socketio
from controller.mobile import Mobile

class Controller:

    def __init__(self,code = 'a1b2c3'):
        # Room Code
        self.code = code

        # Socket IO Communication Protocol Definition
        sio = socketio.Client()

        @sio.event
        def connect():
            print("I'm connected!")

        @sio.event
        def connect_error():
            print("The connection failed!")

        @sio.event
        def disconnect():
            print("I'm disconnected!")

        @sio.event(namespace='/'+code)
        def message(data):
            print('I received a message!')
        
        @sio.event(namespace='/'+code)
        def multicast(data):
            print('Multicast received!')
            print(data)

        @sio.on('my message',namespace='/'+code)
        def on_message(data):
            print('I received a message!')
        
        self.sio = sio
        self.mobiles = {} # id:MOBILE

    def connect(self):
        global code
        self.sio.connect('http://localhost',namespaces=['/'+self.code])
        self.sio.emit('code', {'code': self.code})
    
    def disconnect(self):
        self.sio.disconnect()
    
    def getMobiles(self):
        return self.mobiles

    def create_mobile(self,id):
        self.mobiles[id] = Mobile(id)
    
    

    
    
