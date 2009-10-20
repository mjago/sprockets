#~ require 'find'

#~ ignored_extensions = [".cs",".txt"]

#~ Find.find("C:/s/sprockets") do |file|
	#~ next if ignored_extensions.include?(File.extname(file))
	#~ puts "* #{file}"
#~ end

require 'yaml'

o = [ 'array', 'of', 'items' ]


o2 = YAML::load( o.to_yaml )

test = YAML::load( File.open( 'test.yml' ) )

#~ puts test.inspect

#~ puts test['letters to']['Myself']['diary']['daily entry']
#~ puts test['letters to']['Myself']['diary']['weekly entry']
puts test['folder1']['folder2'].size
#~ test[folder1].each do |e|
	#~ puts e.inspect
#~ end
