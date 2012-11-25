require "netruby.rb"

class Connect
def initialize(server="",port=0,socket=true)
	@netruby = Netruby.new(server,port,socket)
end

def ping(n=10)
	for i in 0..n
		t_send = Time.now
		@netruby.send_ping(i)
		recv = @netruby.recv
		if recv[:type] == :PONG then
			puts recv[:payload][:count].to_s + " nach " + ((Time.now-t_send)*1000).to_s + " ms"
		else
			puts "ERROR, gets Type: " + recv[:type].to_s
		end
	end
end

def send_s(sequenze) 
	@netruby.send_request("test",1,sequenze.metadata)
	recv = @netruby.recv
	if recv[:type] != :ACK then
		puts "ERROR: ACK required, get: " + recv[:type].to_s
	end
	recv = @netruby.recv
	if recv[:type] != :START then
		puts "ERROR: START required, get: " + recv[:type].to_s
	end
	threats = []
	threats[0] = Thread.new(sequenze) {|seq|
		seq.frame.each { |frame|
			@netruby.send_frame(frame)
		}		
		threats[1].exit
		@netruby.close_socket
	}
        threats[1] = Thread.new() {
	recv = @netruby.recv
	if recv[:type] != nil then
		puts "2"
		puts "ERROR: recive: " + recv[:type].to_s
		threats[0].exit	
	end
	}
	threats.each { |aThread| aThread.join }
end

def server 
	recv = @netruby.recv
	if recv[:type] != :REQUEST then
		puts "ERROR: Request required, get: " + recv[:type].to_s
	end
	sequenze = Fullcircle::BinarySequence.new
	sequenze.metadata = recv[:payload][:meta]
	@netruby.send_ack
	@netruby.send_start
	recv = @netruby.recv
	while (recv[:type]==:FRAME)
		sequenze.frame << recv[:payload][:frame]
		recv = @netruby.recv
		if recv[:type] == :EOS
			break
		end
	end
	return sequenze
end

end

