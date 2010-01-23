require 'yaml'
require 'pp'   

p=YAML::load_file("listOnRepo.yaml")
            
pp p["core"]