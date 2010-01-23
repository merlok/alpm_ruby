module Parser
   
def Parser.getFirstServer(filemirror)
  File.foreach(filemirror.strip) { |line| 
   if line=~/^\s*Server\s*=\s*/
     return $'
   end
 }
end


def Parser.parse

  file="/etc/pacman.conf"

  #struttura per le opzioni
  options={:HoldPkg => "",
           :SyncFirst => "",
           :DBPath => "/var/lib/pacman",
           :RootDir => "/",
           :CacheDir => "/var/cache/pacman/pkg",
           :LogFile => "",
           :IgnorePkg => "",
           :IgnoreGroup => "",
           :NoUpgrade => "",
           :NoExtract=> "",
           :XferCommand => "",
           :CleanMethod => "",
  }
  #struttura per i repository
  repourl={
  }

    File.open(file, "r") { |file| file.each_line { |line|
      key=line.split[0]
      if options.include? key then
        line=~/.*=\s*/
        options[key]=$'
      end
      
      if key=~/^\[(.*)\]/ then
        if $1!="options" then
          repo=$1
          nextline=file.readline
          while not(nextline=~/^\s*Server\s*=\s*/) and not(nextline=~/^\s*Include\s*=\s*/)
            nextline=file.readline
          end
          url=$'
          if nextline=~/^\s*Include\s*=\s*/
            url=Parser.getFirstServer($')
            url["$repo"]=repo
          end
          repourl.store(repo,url)
        end                            
      end
    }

  }
  return options,repourl
end  

end


if __FILE__==$0
  options,repourl=Parser.parse()
  puts "repourl\n"  
  repourl.each { |k,v| puts "#{k} => #{v}" }
  puts "options\n"
  options.each { |k,v| puts "#{k} => #{v}" if v!=nil  }
end
  
  