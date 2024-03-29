require "netruby.rb"

class Connect
def initialize(server="",port=0,socket=true)
	@netruby = Netruby.new(server,port,socket)
	@timeout = 0
	@n_abort = 0
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
	fps = sequenze.metadata.frames_per_second
	@netruby.send_request("test",1,sequenze.metadata)
	puts 'Send Request, Wait for ACK'
	recv = @netruby.recv
	if recv[:type] != :ACK then
		puts "ERROR: ACK required, get: " + recv[:type].to_s
	end
	puts 'Wait for Start'
	recv = @netruby.recv
	if recv[:type] != :START then
		puts "ERROR: START required, get: " + recv[:type].to_s
	end
	threats = []
	now = Time.new
	threats[0] = Thread.new(sequenze) {|seq|
		seq.frame.each { |frame|
			@netruby.send_frame(frame)
			sleep((1.0/fps.to_f)-(Time.new-now))
			now = Time.new
			puts "sleep for " + (1.0/fps.to_f).to_s
		}
		threats[1].exit
		@netruby.send_eos
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
	@netruby.close_socket
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
	time_s = Time.now
	n = 0
	while (recv[:type]==:FRAME)
		sequenze.frame << recv[:payload][:frame]
		recv = @netruby.recv
		n = n + 1
		if recv[:type] == :EOS
			break
		end
		if @timeout > 0 && (Time.now-time_s) >= @timeout then
			@netruby.send_timeout
			puts "Timeout! After " + (Time.now-time_s).to_s + " sec"
			break
		end
		if @n_abort > 0 && n >= @n_abort then
			@netruby.send_abort
			puts "ABORT! After " + n.to_s + " Tryes"
			break
		end
	end
	return sequenze
end

def set_timeout(timeout)
	@timeout = timeout
end

def set_abort(n)
	@n_abort = n
end

end
