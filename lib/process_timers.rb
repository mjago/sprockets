class ProcessTimers

	def initialize
		self.reset
	end
	
	def process_timers
    time_running = (Time.now - @time_started)
    if time_running.to_i > @seconds_count
			STDOUT.puts "."
			STDOUT.flush
			@seconds_count = time_running.to_i
    end
		@seconds_count
	end	
	
	def reset
		@seconds_count = 0
		@time_started = Time.now
			end
end
