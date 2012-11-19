#!/usr/bin/ruby

require 'rubygems'
require 'sequence.pb.rb'
require 'socket'

printf "Insert count:"
count = gets
count.chomp!
puts "Eingabe: " + count.to_i.to_s

# Create Sniped to send
snip_send = Fullcircle::Snip.new

#Set Type of Send Snip
snip_send.type = Fullcircle::Snip::SnipType::PING

#Set Count of Ping
pingsnip = Fullcircle::Snip::PingSnip.new
pingsnip.count = count.to_i
snip_send.ping_snip = pingsnip

#serialize snip
body_send = snip_send.serialize_to_string
body_send_length = body_send.length
# Header = 10 Byte with length of body at the end ("         6")
header_send = body_send_length.to_s.rjust(10)
message = header_send + body_send

# Send the message
conn = TCPSocket.new("10.23.42.158",24567)
conn.print message

# Recive Header
header_recv = conn.recv(10)
body_recv = conn.recv(header_recv.to_i)

conn.close
 
snip_recv = Fullcircle::Snip.new
snip_recv.parse_from_string(body_recv)

if snip_recv.type == Fullcircle::Snip::SnipType::PONG then
	puts "Pong: " + snip_recv.pong_snip.count.to_s
else
	puts "Error: Server answer not type PONG!"
end
exit
