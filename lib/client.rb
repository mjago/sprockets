require 'socket'

def update_file(name,s)
  File.open(name,"w") do |f|
    while line = s.gets do
      return if line.strip == '\0'
      f.STDOUT.puts line.chop
    end
  end
end

def run_specs
	temp =	%x{spec.bat ../spec/server_spec.rb --colour --format html:\"../spec/spec_output.html\" --format specdoc}
	STDOUT.puts temp.class
#~ temp = `spec \"server_spec.rb --colour --format html:\"spec_output.html\" --format specdoc\"`
	STDOUT.puts temp
	STDOUT.flush
end

@start_time = Time.new
hostname = '192.168.10.57'
port = 2000
STDOUT.puts "hostname = #{hostname}"
STDOUT.puts "port = #{port}"
STDOUT.flush
count = 0
loop do
  STDOUT.puts "looking for server"  
  STDOUT.flush
  begin 

    s = TCPSocket.open(hostname,port)

    while line = s.gets do
      @start_time = Time.now
      if line.strip == 'tick'
        STDOUT.print '.'
        STDOUT.flush
        count += 1
        if count >= 5
          count = 0
          STDOUT.puts
          STDOUT.flush
        end
      elsif line.include?('filename')
        file_name = line[line.index('filename = ') + 'filename = '.length .. -2]
        STDOUT.puts
        STDOUT.puts "updating #{file_name}"
        STDOUT.flush
        update_file(file_name,s)
				run_specs
        count = 0
      end
    end

  rescue
  
    sleep 1

  else
    
 end

end

STDOUT.puts "finished in #{Time.now - @start_time} seconds"
STDOUT.flush

exit

