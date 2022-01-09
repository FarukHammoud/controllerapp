

def get_mac():
    from uuid import getnode as get_mac
    macint = get_mac()
    if type(macint) != int:
        raise ValueError('invalid integer')
    return ':'.join(['{}{}'.format(a, b)
                     for a, b
                     in zip(*[iter('{:012x}'.format(macint))]*2)])
print(get_mac())