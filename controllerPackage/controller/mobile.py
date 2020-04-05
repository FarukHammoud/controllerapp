class Mobile:
    
    def __init__(self,id,help=False):
        self.id = id
        self.help = help

    def handle(self,data):
        if not self.id == data['id']:
            print('Its not my problem')
        else:
            print('ill handle it!')
    def on_left_swipe(self):
        if self.help:
            print('[LEFT SWIPE DETECTED] You can overwrite on_left_swipe to handle it.')

    def on_right_swipe(self):
        if self.help:
            print('[RIGHT SWIPE DETECTED] You can overwrite on_right_swipe to handle it.')

    def on_up_swipe(self):
        if self.help:
            print('[UP SWIPE DETECTED] You can overwrite on_up_swipe to handle it.')

    def on_down_swipe(self):
        if self.help:
            print('[DOWN SWIPE DETECTED] You can overwrite on_down_swipe to handle it.')
    