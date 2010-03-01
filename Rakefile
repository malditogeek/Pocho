task :default => [:test]

# Test
desc 'Run Pocho tests, make Pocho sweat.'
task :test do
  ruby 'test/pocho_web_test.rb'
end

# Bot control
desc 'Wake up the beast, Pocho bot.'
task :launch_bot do
  ruby 'bot_control.rb start'
end

desc 'Pocho bot over and out.'
task :stop_bot do
  ruby 'bot_control.rb stop'
end

# Sinatra
desc 'Pocho takes the stage.'
task :launch_web do
  ruby 'pocho_web.rb'
end

