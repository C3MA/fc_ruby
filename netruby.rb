#!/usr/bin/ruby

require 'rubygems'
require 'sequence.pb.rb'
require 'socket'

class Netruby
def initialize(server="",port=0,socket=true)
	if socket == true then
		@socket = TCPSocket.new(server,port)
	else
		@server = TCPServer.new(port)
		@socket = @server.accept
	end
	@snipin = Fullcircle::Snip.new
	@snipout = Fullcircle::Snip.new
end

def close_socket
	@socket.close
end

def reaccept
	@socket = @server.accept
end

def send
	@socket.print serialize(@snipout)
	@snipout = Fullcircle::Snip.new
end

def recv
	header = @socket.recv(10)
	if not header =~ /^[ ]{0,}[0-9]{1,}$/
		puts "ERROR: Header from Server not match"
		exit
	end
	payload = @socket.recv(header.to_i)
	@snipin.parse_from_string(payload)
	case @snipin.type
		when Fullcircle::Snip::SnipType::PING
			return {:type => :PING, :payload => recv_ping}
		when Fullcircle::Snip::SnipType::PONG
			return {:type => :PONG, :payload => recv_pong}
		when Fullcircle::Snip::SnipType::ERROR
			return {:type => :ERROR, :payload => recv_error}
		when Fullcircle::Snip::SnipType::REQUEST
			return {:type => :REQUEST, :payload => recv_request}
		when Fullcircle::Snip::SnipType::START
			return {:type => :START}
		when Fullcircle::Snip::SnipType::FRAME
			return {:type => :FRAME, :payload => recv_frame}
		when Fullcircle::Snip::SnipType::ACK
			return {:type => :ACK}
		when Fullcircle::Snip::SnipType::NACK
			return {:type => :NACK}
		when Fullcircle::Snip::SnipType::TIMEOUT
			return {:type => :TIMEOUT}
		when Fullcircle::Snip::SnipType::ABORT
			return {:type => :ABORT}
	else
		puts "Unnown Answer"
	end	
end

def serialize(payload)
	payload_serialized = payload.serialize_to_string
	payload_length = payload_serialized.length
	header= payload_length.to_s.rjust(10)
	return header+payload_serialized
end

def send_ping(count)
	@snipout.type = Fullcircle::Snip::SnipType::PING
	pingsnip = Fullcircle::Snip::PingSnip.new
	pingsnip.count = count
	@snipout.ping_snip = pingsnip
	send	
end

def recv_ping
	return @snipin.ping_snip.to_hash
end

def send_pong(count)
        @snipout.type = Fullcircle::Snip::SnipType::PONG
        pongsnip = Fullcircle::Snip::PongSnip.new
        pongsnip.count = count
        @snipout.pong_snip = pongsnip
        send    
end

def recv_pong
	return @snipin.pong_snip.to_hash
end

def send_error(errortype,description)
	@snipout.type = Fullcircle::Snip::SnipType::ERROR
	errorsnip = Fullcircle::Snip::ErrorSnip.new
	errortypesnip = Fullcircle::Snip::ErrorCodeType.new
	errortypesnip = errortype
	errorsnip.errorcode = errortypesnip
	errorsnip.description = description
	@snipout.error_snip = errorsnip
	send
end

def recv_error
	return @snipin.error_snip.to_hash
end

def send_request(color,seqid,meta)
	@snipout.type = Fullcircle::Snip::SnipType::REQUEST
	reqsnip = Fullcircle::Snip::RequestSnip.new
	reqsnip.color = color
	reqsnip.seqId = seqid
	reqsnip.meta = meta
	@snipout.req_snip = reqsnip
	send
end

def recv_request
	return @snipin.req_snip.to_hash
end

def send_start
	@snipout.type = Fullcircle::Snip::SnipType::START
	startsnip = Fullcircle::Snip::StartSnip.new
	@snipout.start_snip = startsnip
	send
end

def send_frame(frame)
	@snipout.type = Fullcircle::Snip::SnipType::FRAME
	framesnip = Fullcircle::Snip::FrameSnip.new
	framesnip.frame = frame
	@snipout.frame_snip = framesnip
	send
end

def recv_frame 
	return @snipin.frame_snip.to_hash
end

def send_ack
	@snipout.type = Fullcircle::Snip::SnipType::ACK
	acksnip = Fullcircle::Snip::AckSnip.new
	@snipout.ack_snip = acksnip
	send
end

def send_nack                  
        @snipout.type = Fullcircle::Snip::SnipType::NACK
        nacksnip = Fullcircle::Snip::NackSnip.new
        @snipout.nack_snip = nacksnip
        send
end

def send_timeout
	@snipout.type = Fullcircle::Snip::SnipType::TIMEOUT
	timeoutsnip = Fullcircle::Snip::TimeoutSnip.new
	@snipout.timeout_snip = timeoutsnip
	send
end

def send_abort
	@snipout.type = Fullcircle::Snip::SnipType::ABORT
	abortsnip = Fullcircle::Snip::AbortSnip.new
	@snipout.abort_snip = abortsnip
	send
end

def get_socket
	return @socket
end

end
