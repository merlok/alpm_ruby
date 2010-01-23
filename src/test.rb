require 'parsePac.rb'
require 'rbAlpm.rb'
require 'alpmFunc.rb'
require 'yaml' 
require "pp"

module TEST
  @g = Alpm_use::Alpm_method.new;
  @g.initAlpm;
#  @g.addToHash.each_pair{
#    |k,v| puts k.to_s
#    v.each_pair{|k1,v1|
#     puts k1.to_s
#     v1.each_pair{|k2,v2|
#      puts k2.to_s+"=>"+v2.to_s 
#     }
#    }
#  }
  @g.getSyncPkgs do |pkgInfo|
    pp "Descrizione #{pkgInfo[:desc]}" 
    pp "Name #{pkgInfo[:name]}" 
    pp "Version #{pkgInfo[:version]}" 
    pp "Size #{pkgInfo[:size]}" 
    pp "Rep #{pkgInfo[:repo]}" 
  end
  @g.close
end 
