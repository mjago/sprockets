
watch(".*") do |md| 
	source_base = "C:\\s\\sprockets\\"
	destination_base = "/"
	puts "md = #{md.to_s}"
	source = source_base + md.to_s.gsub('/','\\')
	puts "source = #{source.to_s}"
	destination = destination_base + md.to_s
	puts "destination = #{destination}"
	`"C:/Program Files/winSCP/winSCP.exe" /command "option confirm off" "open martyn@192.168.10.91"  "put #{source} #{destination} "`
end

