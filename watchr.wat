
watch("spec/comms_driver_state_spec.rb") do |sm|
  sm.gsub!('state_spec','state_machine')
  STDOUT.puts "drawing #{sm}"
 STDOUT.puts system("ruby lib/draw_state_machine.rb #{File.basename(sm,'.rb')}")
end

