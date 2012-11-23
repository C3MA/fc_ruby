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
		if recv[:type] == :PING then
			puts recv[:count].to_s + " nach " + (Time.now-t_send) + " s"
		else
			puts "ERROR, gets Type: " + recv[:type].to_s
		end
	end
end



end
