"""
A simple Python script to receive messages from a client over
Bluetooth using Python sockets (with Python 3.3 (Linux) 3.10 (Windows) or above).
"""

import socket

def get_mac():
    from uuid import getnode as get_mac
    macint = get_mac()
    if type(macint) != int:
        raise ValueError('invalid integer')
    return ':'.join(['{}{}'.format(a, b)
                     for a, b
                     in zip(*[iter('{:012x}'.format(macint))]*2)])

hostMACAddress = get_mac() # The MAC address of a Bluetooth adapter on the server. The server might have multiple Bluetooth adapters.
print("Your MAC Adress is "+hostMACAddress)
port = 4 # 3 is an arbitrary choice. However, it must match the port used by the client.
backlog = 1
size = 1024
s = socket.socket(socket.AF_BLUETOOTH, socket.SOCK_STREAM, socket.BTPROTO_RFCOMM)
s.bind((hostMACAddress,port))
s.listen(backlog)
try:
    client, address = s.accept()
    while 1:
        data = client.recv(size)
        if data:
            print(data)
            client.send(data)
except:	
    print("Closing socket")	
    client.close()
    s.close()