=begin rdoc
= generate tertiary_state_machine
=end

def draw_state_machine
	require File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','docs','lib','graph_lib','graph_lib'))
	require File.expand_path(File.join(File.dirname(__FILE__),'main_states'))
	
	@out_path = File.expand_path(File.join(File.dirname(__FILE__),''))
	
	gvr = GraphvizR.new 'draw_state_machine'
	
	gvr.graph[:label => "\n\nTertiary Main State Machine",
								:bgcolor => :white, 
								:rankdir => "UD"
							]
	gvr.edge [:color=>:midnightblue, 
								:url => 'http://google.com'
	]
	gvr.node [:color=>:black, 
								:style=>:filled,
								:fillcolor=>:lightblue,
								:shape=>:box, 
								:url => 'http://google.com'
	]

	States.main.each do |st|
		gvr[st[0].to_s.to_sym] [:label => st[0].to_s.gsub("_","\n")]
		(gvr[st[0].to_s.to_sym] >> gvr[st[2].to_s.to_sym])[:label => st[1].to_s.gsub("_","\n")]
	end	
	
	
	generate_graph(gvr, File.expand_path(File.join(File.dirname(__FILE__), 'temp_tertiary_state_machine')),'svg')
	generate_graph(gvr, File.expand_path(File.join(File.dirname(__FILE__), 'tertiary_state_machine')),'pdf')
	system('C:\libxslt\bin\xsltproc C:\libxslt\pretty.xsl temp_tertiary_state_machine.svg > tertiary_state_machine.svg')
end

if $0 ==__FILE__
	draw_state_machine 
	display_graph(File.expand_path(File.join(File.dirname(__FILE__), 'tertiary_state_machine.pdf'))) 
end	
