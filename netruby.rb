#!/usr/bin/ruby

require 'rubygems'
require 'sequence.pb.rb'
require 'socket'



class Netruby
def initialize(server="",port=0)
	@server = server
	@port = port
	@socket = opensocket
	@snipin = Fullcircle::Snip.new
	@snipout = Fullcircle::Snip.new
end

def opensocket
	TCPSocket.new(@server,@port)
end 

def closesocket
	@socket.close
end

def send
	@socket.print serialize(@snipout)
	@snipout = Fullcircle::Snip.new
end

def recv
	header = @socket.recv(10)
	if not header =~ /^[ ]{0,}[0-9]{1,}$/
		puts "ERROR: Header from Server not match"
		closesocket
		exit
	end
	payload = @socket.recv(header.to_i)
	@snipin.parse_from_string(payload)
	case @snipin.type
		when Fullcircle::Snip::SnipType::PING
			return ["PING",recv_ping]
		when Fullcircle::Snip::SnipType::PONG
			return ["PONG",recv_pong]
		when Fullcircle::Snip::SnipType::ERROR
			return ["ERROR",recv_error]
		when Fullcircle::Snip::SnipType::REQUEST
			return ["REQUEST",recv_request]
		when Fullcircle::Snip::SnipType::START
			return ["START",recv_start]
		when Fullcircle::Snip::SnipType::FRAME
			return ["FRAME",recv_frame]
		when Fullcircle::Snip::SnipType::ACK
			return ["ACK",recv_ack]
		when Fullcircle::Snip::SnipType::NACK
			return ["NACK",recv_nack]
		when Fullcircle::Snip::SnipType::TIMEOUT
			return ["TIMEOUT",recv_timeout]
		when Fullcircle::Snip::SnipType::ABORT
			return ["ABORT",recv_abort]
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
	return @snipin.ping_snip
end

def send_pong(count)
        @snipout.type = Fullcircle::Snip::SnipType::PONG
        pongsnip = Fullcircle::Snip::PongSnip.new
        pongsnip.count = count
        @snipout.pong_snip = pongsnip
        send    
end

def recv_pong
	return @snipin.pong_snip
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
	return @snipin.error_snip
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
	return @snipin.req_snip
end

def send_start
	@snipout.type = Fullcircle::Snip::SnipType::START
	startsnip = Fullcircle::Snip::StartSnip.new
	@snipout.start_snip = startsnip
	send
end

def recv_start
	return @snipin.start_snip
end

def send_frame(frame)
	@snipout.type = Fullcircle::Snip::SnipType::FRAME
	framesnip = Fullcircle::Snip::FrameSnip.new
	framesnip.frame = frame
	@snipout.frame_snip = framesnip
	send
end

def recv_frame 
	return @snipin.frame_snip
end

def send_ack
	@snipout.type = Fullcircle::Snip::SnipType::ACK
	acksnip = Fullcircle::Snip::AckSnip.new
	@snipout.ack_snip = acksnip
	send
end

def recv_ack
	return @snipin.ack_snip
end

def send_nack                  
        @snipout.type = Fullcircle::Snip::SnipType::NACK
        nacksnip = Fullcircle::Snip::NackSnip.new
        @snipout.nack_snip = nacksnip
        send
end

def recv_nack          
        return @snipin.nack_snip
end

def send_timeout
	@snipout.type = Fullcircle::Snip::SnipType::TIMEOUT
	timeoutsnip = Fullcircle::Snip::TimeoutSnip.new
	@snipout.timeout_snip = timeoutsnip
	send
end

def recv_timeout
	return @snipin.timeout_snip
end

def send_abort
	@snipout.type = Fullcircle::Snip::SnipType::ABORT
	abortsnip = Fullcircle::Snip::AbortSnip.new
	@snipout.abort_snip = abortsnip
	send
end

def recv_abort
	return @snipin.abort_snip
end


end
