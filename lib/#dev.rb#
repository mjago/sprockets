  require 'socket'               # Get sockets from stdlib
  require 'find'
  
  DEV_SOCKET = 2000
  TEST_SOCKET = 2001

  class DevSocket
    def open_socket(port)
      @dev = TCPServer.open(port)  # Socket to listen on port 2000
    end
    def wait_for_test
      loop do
        STDOUT.puts 'waiting for tester'
        STDOUT.flush
        break if tester_responded?
      end
    end
    def tester_responded?
      begin
        @tester = @dev.accept_nonblock
      rescue
        sleep 1
        return false	
        STDOUT.puts 'tester responded'
        STDOUT.flush
        return true
      end
    end

    def daemon
      
      loop do
        STDOUT.puts "looking for tester"
        STDOUT.flush
        begin
          s = TCPSocket.open('192.168.10.91',3001)
          
          while line = s.gets do
            puts line
          end
        end
      end
      
      count = 0
      loop do
        @tester.puts "tick"
        STDOUT.print "."
        STDOUT.flush
        count += 1
        if count >= 5
          count = 0
          STDOUT.puts 
          STDOUT.flush
        end
        sleep 1
      end
    end

  end

  if $0 == __FILE__
    dev = DevSocket.new
    dev.open_socket(DEV_SOCKET)
    dev.wait_for_test
    dev.daemon
  end


