require 'yaml'
test={:a=>{:pippo=>{:desk=>"ciao",:size=>30},:test=>{:desk=>"ciao",:size=>30}}}

File.open("test.Yaml", "w") { |file| file.write(YAML::dump(test))  }