
module PARSEPAC
  
  class PARSE
    #declare a "struct" for contains the principal entryes of pacman.conf
     @holdPkg = Array.new
     @syncFirst = Array.new
     @xfer
     @ignorePkg = Array.new
     @ignoreGrp = Array.new
     @noExt = Array.new
     @dbName = Array.new
     @url = Array.new   
     @noUp = Array.new
     def initialize
       @holdPkg = [];
       @dbName = [];
       @xfer = "";
       @ignorePkg = [];
       @noExt = [];
       @url = [];
       @ignoreGrp = [];
       @syncFirst = [];
       @noUp = [];
     end
     attr_accessor :holdPkg, :syncFirst, :ignorePkg, :noExt, :dbName, :url, :xfer, :ignoreGrp, :noUp
  end
  
  class EXEC
    
    def parsed
      
      parser = PARSE.new;
      f = File.open("/etc/pacman.conf", "r");
      while !f.eof do
	line = f.readline;
	#Jump commented and empyt lines
	if ( line[0..0] == "#" ) or ( line.length - 1 == 0 )
	  next;
	end
	#Split the string for the character "="
	split_str = line.split('=');
	#If the length of the split is 1 then the lines is a db name
	if split_str.length == 1
	  splitted = split_str[0];
	  n = splitted.length-2;
	  if ( splitted[0..0] == "[" ) and ( splitted[n..n] == "]") and ( splitted != "[options]\n")
	    parser.dbName << splitted[1..n-1]
	    next;
	  end
	end
	#Delete all the space in the first position of the splitted line
	#and search the entry of pacman.conf
	while (split_str[0][" "])
	  split_str[0][" "]="";
	end
	if split_str[0] == "HoldPkg"
	  parser.holdPkg << split_str[1].split(" ");
	  next;
	end
	if split_str[0] == "SyncFirst"
	  parser.syncFirst << split_str[1].split(" ");
	  next;
	end
	if split_str[0] == "IgnorePkg"
	  parser.ignorePkg << split_str[1].split(" ");
	  next;
	end
	if split_str[0] == "XferCommand"
	  parser.xfer=split_str[1];
	  next;
	end
	if split_str[0] == "IgnoreGroup"
	  parser.ignoreGrp << split_str[1].split(" ");
	  next;
	end
	if split_str[0] == "Server"
	  parser.url << split_str[1].split(" ");
	  next;
	end
	if split_str[0] == "NoUpgrade"
	  parser.noUp << split_str[1].split(" ");
	  next;
	end
      end
      f.close();
      return parser;
    end
  end
end
