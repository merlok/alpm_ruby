require 'dl'
i = 0
file="/usr/include/alpm.h"

File.open(file,"r") {
  |f| f.each_line { |line|
    line =~ /^\s*(\w+\s\w+\s|\w+\s).(\w+)(\(.*)/
    puts "#{$1} #{$2} #{$3}" if $2 != nil
    i+=1 if $2 != nil
  }
}
puts i
