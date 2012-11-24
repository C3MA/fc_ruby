require "netruby.rb"

class Connect
def initialize(server="",port=0)
	@netruby = Netruby.new(server,port)
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

end
