#!/usr/bin/python

import  socket, sys

port = sys.argv[1]
nport = socket.htons(int(port))
print "Port in hex Network Byte order:" ,hex(nport)
