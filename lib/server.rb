
CODE_PATH = File.expand_path(File.join(File.dirname(__FILE__),'..'))

class ConsoleSocket
  require 'socket'               # Get sockets from stdlib
  require 'statemachine'
  
  def initialize
  end
  
  def wait_for_client
    loop do
      STDOUT.puts 'waiting for client'
      STDOUT.flush
      break if client_responded?
    end
  end
  
  def open_socket(port)
    @server = TCPServer.open(port)  # Socket to listen on port 2000
  end
  
  def close_socket
    @server = nil
  end
  
  def client_responded?
    begin
      @client = @server.accept_nonblock
    rescue
      sleep 1
      return false	
      STDOUT.puts 'client responded'
      STDOUT.flush
      return true
    end
  end
  
  def build_file_tree
    @files = {}
    Dir[CODE_PATH + "/*"].each do |dir|
      if File.directory?(dir)
        %w{c h rb lkr}.each do |extension|
          Dir[dir + "/*.#{extension}"].each do |file|
            @files[file] = File.mtime(file)
          end
        end
      end
    end	
    puts @files.inspect
  end

  def send_file(file)
    @client.puts "filename = #{file}"
    STDOUT.puts 
    STDOUT.puts "sending #{file}"
    STDOUT.flush
    File.open(file) do |f|
      f.readlines.each do |line|
        @client.puts line
      end
      @client.puts '\0'
    end
  end
  
  def transfer_files(path,extension,c)
    Dir[path + "/*.#{extension}"].each do |file|
      puts "transfering file #{File.basename(file)}"
      send_file(file)
    end
  end

  def daemon
    count = 0
    loop do
      @client.puts "tick"
      STDOUT.print "."
      STDOUT.flush
      count += 1
      if count >= 5
        count = 0
        STDOUT.puts 
        STDOUT.flush
      end
      sleep 1
      @files.each_key do |file|
        if @files[file] != File.mtime(file)
          @files[file] = File.mtime(file)
          @client.puts
          send_file(file)
          @client.puts
          count = 0
        end
      end
    end
  end
  
  def test
    count = 0
    loop do
      if count == 5
        count = 0
        Dir[CODE_PATH + "/*"].each do |dir|
          puts dir
          if File.directory?(dir)
            %w{c h rb lkr}.each do |extension|
              transfer_files(dir,extension,@client)
            end
          end
        end
      end  
      @client.puts "tick"
      STDOUT.print "."
      STDOUT.flush
      count += 1
      sleep 1
    end
  end
end

if $0 == __FILE__
  #~ ConsoleSocket.new.test
  m = ConsoleSocket.new
  m.build_file_tree
  m.open_socket(2000)
  m.wait_for_client
  m.daemon
end

