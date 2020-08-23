#!/usr/bin/python

import socket, struct, sys
ip=sys.argv[1]
tip = socket.inet_aton(ip)
print "IP in hex Network Byte Order : ", '0x' + hex(struct.unpack("!L", tip[::-1])[0])[2:].zfill(8)
port = sys.argv[2]
nport = socket.htons(int(port))
print "Port in hex Network Byte order : " , hex(nport)
