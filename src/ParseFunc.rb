require "jcode"

def params(r) 
  result=""
  i=0
  r[1..-1].each_char { |chr| 
    result +="param#{i},"
    i+=1
  }
  result[-1]=""
  return result
end

File.open("./protot.txt", "w") { |filew|  
File.open("./rbAlpm.rb", "r") { |file|
   file.each_line { |line|  
     line=~/:.*\['(.*)','(.*)'\]/
     if $2!=nil
       param=params($2) if $2.length>1
     end
     filew.write("def #{$1}(#{param})\n    r,rs = SYM[:#{$1}].call(#{param})\n    return r\nend\n\n") if $1!=nil
    
     }  
     }
}

