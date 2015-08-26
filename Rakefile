require 'rake'

# Find application support path
home_path = File.expand_path(ENV['HOME'])
dropbox_appsupport_path = File.join(home_path, 'Dropbox', 'Application Support', 'BBEdit')
local_appsupport_path = File.join(home_path, 'Library', 'Application Support', 'BBEdit')
appsupport_path = File.exist?(dropbox_appsupport_path) ? dropbox_appsupport_path : local_appsupport_path

src_scripts = Dir.glob("Scripts/*.applescript").map { |f| File.join(File.dirname(f), File.basename(f, ".applescript") + ".scpt") }

task :default => [ :scripts ]

desc "Compile AppleScripts to objects"
task :scripts => src_scripts

task :clean do
  src_scripts.each { |f| rm_f f }
end

task :install => [ :scripts ] do
  scripts_dir = File.join(appsupport_path, 'Scripts')
  src_scripts.each { |f| cp(f, scripts_dir) }
end

task :uninstall do
  scripts_dir = File.join(appsupport_path, 'Scripts')
  src_scripts.each { |f| rm_f File.join(appsupport_path, f) }
end

rule ".scpt" => ".applescript" do |t|
  puts "Compiling #{t.source} -> #{t.name}"
  sh "osacompile -o '#{t.name}' '#{t.source}'"
end

task :install do
end
