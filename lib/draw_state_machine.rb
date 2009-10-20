
=begin rdoc
= generate tertiary_state_machine
=end

require File.expand_path(File.join(File.dirname(__FILE__),'graph_lib','graph_lib'))
require File.expand_path(File.join(File.dirname(__FILE__),'state_data'))

class String
   def titlecase
      non_capitalized = %w{of etc and by the for on is at to but nor or a via}
      gsub(/\b[a-z]+/){ |w| non_capitalized.include?(w) ? w : w.capitalize  }.sub(/^[a-z]/){|l| l.upcase }.sub(/\b[a-z][^\s]*?$/){|l| l.capitalize }
   end
 end
 
def draw_state_machine(state_machine_name)
	
	@state_machine_name = state_machine_name
	
	gvr = GraphvizR.new @state_machine_name
	
	gvr.graph[:label => "\n\n#{@state_machine_name.gsub('_',' ').to_s.titlecase}",
								:bgcolor => :white, 
								:rankdir => "UD"
							]
	gvr.edge [:color=>:midnightblue, 
								:color=>:green, 
								:fontname => 'verdana',
								:fontsize => '16',
								:fontcolor => :darkgreen,
								:url => 'http://google.com'
	]
	gvr.node [:color=>:black, 
								:fontcolor => :navyblue,
								:fontname => 'verdana',
								:fontsize => '16',
								:style=>:filled,
								:fillcolor=>:lightblue,
								:shape=>:circle,#:box, 
								:url => 'http://google.com'
	]

	#~ StateData.connection_state_data.each do |st|
	#~ StateData.dev_tx_messaging_state_data.each do |st|
	#~ StateData.dev_rx_messaging_state_data.each do |st|
	#~ StateData.dev_main_state_data.each do |st|

	#~ StateData.tester_tx_messaging_state_data.each do |st|
	#~ StateData.tester_rx_messaging_state_data.each do |st|
	
	StateData.send(@state_machine_name.gsub('_machine','_data')).each do |st|
	#~ StateData.singleton_methods.each do |instance_method|
#~ puts "instance method = #{instance_method}"
		#~ if instance_method.include?('_data') 
			#~ state_data = StateData.send(instance_method)
			#~ puts state_data.inspect
			#~ puts "drawing #{instance_method}"
			#~ state_data.each do |st|
		gvr[st[0].to_s.to_sym] [:label => st[0].to_s.gsub("_","\n")]
		(gvr[st[0].to_s.to_sym] >> gvr[st[2].to_s.to_sym])[:label => st[1].to_s.gsub("_","\n")]
	end		
	generate_graph(gvr, File.expand_path(File.join(
		File.dirname(__FILE__), "temp_#{@state_machine_name}")),'svg')
		generate_graph(gvr, File.expand_path(File.join(File.dirname(__FILE__), @state_machine_name)) ,'pdf')
		system(
		  "C:\\libxslt\\bin\\xsltproc #{File.join(File.dirname(__FILE__),'state_machine_format.xsl')} temp_#{@state_machine_name}.svg > #{@state_machine_name}.svg")
		#~ display_graph(File.expand_path(File.join(File.dirname(__FILE__), "#{@state_machine_name}.pdf"))) 
			#~ end
			#~ display_graph(File.expand_path(File.join(File.dirname(__FILE__), "#{instance_method.gsub('_data','_machine')}.pdf"))) 
			
	#~ StateData.tester_main_state_data.each do |st|

		#~ end	
end	

if $0 ==__FILE__
	draw_state_machine('comms_driver_state_machine') 
	display_graph(File.expand_path(File.join(File.dirname(__FILE__), 'comms_driver_state_machine.pdf'))) 
else
	ARGV.each do |sn|
		puts "drawing #{sn}"
		draw_state_machine(sn)
	end
end	
