require 'rake'

scripts = Dir.glob("Scripts/*.applescript").map { |f| File.join(File.dirname(f), File.basename(f, ".applescript") + ".scpt") }
puts scripts

task :default => [ :scripts ]

desc "Compile AppleScripts to objects"
task :scripts => Dir.glob("Scripts/*.applescript").map { |f| File.join(File.dirname(f), File.basename(f, ".applescript") + ".scpt") }
# Dir.glob("Scripts/*.applescript").map { |f| File.basename(f, ".applescript") + ".scpt" }
# [
#   "Scripts/01)ctags.scpt",
#   "Scripts/03)Fit to Screen.scpt",
#   "Scripts/04)Split Vertical.scpt"
# ]

rule ".scpt" => ".applescript" do |t|
  puts "Compiling #{t.source} -> #{t.name}"
  sh "osacompile -o '#{t.name}' '#{t.source}'"
end

task :install do
end
