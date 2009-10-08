require 'graphviz_r'

#   routines for use with grahpvizR class and graphviz

#   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   is this a hidden state ? (val state table to state graph)

def hidden_state?(line)
	hidden_states = 	'NULL_MAIN_STATE', 
				'CONFIRM_TITRATION_DISPLAY_STATE',
				'CONFIRM_TITRATION_INPUT_STATE',
				'CONFIRM_TITRATION_WAIT_STATE',
				'TECHNICIAN_STATE',
				'FINAL_STATE'
	hidden_states.each do |state|
		return true if line == state
	end	
	false
end	

#   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   is this an infusion menu cluster state ? (val state table to state graph)

def infusion_cluster_state?(line)
	infusion_states = 'INFUSION_MENU_DISPLAY_STATE', 
				'INFUSION_MENU_INPUT_STATE',
				'SET_NEOI_DISPLAY_STATE',
				'SET_NEOI_INPUT_STATE'
	infusion_states.each do |state|
		return true if line == state
	end
	false
end	

#   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   is source state ? (val state table to state graph)

def is_source_state_def?(line)
	line.gsub!(" ","")
	
	if line[0.."constucharromsource".length-1] == "constucharromsource"
		return true
	end
	false
end

#   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   is destination state ? (val state table to state graph)

def is_dest_state_def?(line)
	line.gsub!(" ","")
	not line.include? '};' and not line.include? '{' and not line.include? '0'
end			

#   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   extract source state name (val state table to state graph)

def get_source_state(line)
	line.gsub!(" ","")
	line = line["constucharromsource".length..line.index('[')-1]
end

#   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   extract destination state name (val state table to state graph)

def get_dest_state(line)
	line.strip!
	line = line[0..-2]	
end


#   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   generate the dot file and graph - see graphviz for types
#   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   (to send dot conversion to stdout use to_dot)

def generate_graph(graph,name, type)
	graph.output("#{name}.dot","dot")
	command_line = 'cmd.exe /c '
	case type
		when 'pdf'
			if File.exist? name + ".pdf"
				File.delete name + ".pdf"
			end	
			command_line += "dot -Tps2 -o\"#{name}.ps2\" \"#{name}.dot\""
			begin	
				res = system(command_line)
			rescue
				puts "error running #{command_line}"
				exit 1
			end	
			command_line = 'cmd.exe /c '
			command_line += "ps2pdf \"#{name}.ps2\" \"#{name}.pdf\""
		else	
			command_line += "dot -T#{type} -o\"#{name}.#{type}\" \"#{name}.dot\""
	end
	begin	
		res = system(command_line)
	rescue
		puts "error running #{command_line}"
		exit 1
	end	
end	

def display_graph(name)
	command_line = 'cmd.exe /c '
	puts "  displaying #{name} "
	command_line += " \"#{name}\""
	res = system(command_line)
	if not res
		puts "ERROR! displaying graph"
		exit 1
	end	
end

def merge_graphs(graph_list,output)
	puts "compiling state machine book..."
	command_line = 'cmd.exe /c ' + "#{File.expand_path(File.join(__FILE__, "../pdftk"))} " 
	graph_list.each do |graph|
		puts "  #{graph}"
		puts command_line
		command_line += "#{graph} "
	end
	command_line += "  cat output #{output} dont_ask verbose"
	res = system(command_line)
	if not res
		puts "ERROR! merging graphs"
		exit 1
	end
end	
