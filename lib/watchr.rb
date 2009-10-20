

watch("*") do |md| 
#~ "spec/state_machines_spec.rb".each do |md|
#~ "spec/state_machines_spec.rb".each do |md|
	source_base = "C:\\s\\sprockets\\"
		source = source_base + md.gsub('/','\\')
		destination = md
		puts "sending #{source}"
#~ source = "C:\\s\\sprockets\\spec\\state_machines_spec.rb"
#~ destination = "/spec/state_machines_spec.rb"
`"C:/Program Files/winSCP/winSCP.exe" /command "option confirm off" "open martyn@192.168.10.91"  "put #{source} #{destination} "`
end

#`"C:/Program Files/winSCP/winSCP.exe" /command "option confirm off" "open martyn@192.168.10.91"  "put C:\\s\\sprockets\\spec\\state_machines_spec.rb /spec/state_machines_spec.rb"`
