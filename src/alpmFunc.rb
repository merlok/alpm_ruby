#TODO  ricercare anche le dipendenze dei pacchetti da aggiornare.
require 'testpars'
require 'parsePac.rb'
require 'rbAlpm.rb'
require 'dl'
require 'callback.rb'
require "yaml"

module Alpm_use

  class Alpm_method
    PM_TRANS_TYPE_UPGRADE=1
    PM_TRANS_TYPE_REMOVE=2
    PM_TRANS_TYPE_REMOVEUPGRADE=3
    PM_TRANS_TYPE_SYNC=4
    
    PM_TRANS_FLAG_NODEPS = 0x01
    PM_TRANS_FLAG_FORCE = 0x02
    PM_TRANS_FLAG_NOSAVE = 0x04
    #/* 0x08 flag can go here */
    PM_TRANS_FLAG_CASCADE = 0x10
    PM_TRANS_FLAG_RECURSE = 0x20
    PM_TRANS_FLAG_DBONLY = 0x40
    #/* 0x80 flag can go here */
    PM_TRANS_FLAG_ALLDEPS = 0x100
    PM_TRANS_FLAG_DOWNLOADONLY = 0x200
    PM_TRANS_FLAG_NOSCRIPTLET = 0x400
    PM_TRANS_FLAG_NOCONFLICTS = 0x800
    PM_TRANS_FLAG_PRINTURIS = 0x1000
    PM_TRANS_FLAG_NEEDED = 0x2000
    PM_TRANS_FLAG_ALLEXPLICIT = 0x4000
    PM_TRANS_FLAG_UNNEEDED = 0x8000
    PM_TRANS_FLAG_RECURSEALL = 0x10000
    
    $localDb
    $registeredDb
    $dbSync
    #list of package to remove
    $toRemove
    #list of package to install or upgrade
    $toInstall 
    #list of package to install from file
    $toFile
=begin      
    @package = {
      :desc => nil,
      :version => nil,
      :size => nil,
      :repo => nil
    }
=end
    
    def initialize
      $localDb = nil
      $registedDb = nil
      $dbSync = nil
      $toRemove = []
      $toFile = []
      $toInstall = []
      
    end
    
    def initAlpm
      @Alpm=ALPM::Funz.new 
      @options,@repourl=Parser.parse
      i = 0;
      @Alpm.alpm_initialize();
      @Alpm.alpm_option_set_root(@options[:RootDir]);
      @Alpm.alpm_option_set_dbpath(@options[:DBPath]);
      @Alpm.alpm_option_add_cachedir(@options[:CacheDir]);
      $localDb = @Alpm.alpm_db_register_local;
      @listOnRepo={}
      @listOnPkg={}
      #puts $localDb
      @repourl.each_pair { |name, val|   
                                db_sync = @Alpm.alpm_db_register_sync(name)
                                if @Alpm.alpm_db_setserver(db_sync,val) == 0
                        	        $registereddDb = @Alpm.alpm_list_add($registereddDb,db_sync)
                        	      end
                        	      i+=1
                              }
    
       
      
	    @Alpm.alpm_option_set_xfercommand(@options[:XferCommand]) if(@options[:XferCommand] != nil)
      
      @options[:HoldPkg].split(" ").each { |e|  @Alpm.alpm_option_add_holdpkg(e.strip.to_s)}
      @options[:IgnorePkg].split(" ").each { |e|  @Alpm.alpm_option_add_ignorepkg(e.strip.to_s)}
      @options[:IgnoreGroup].split(" ").each { |e|  @Alpm.alpm_option_add_ignoregrp(e.strip.to_s)}   
      @options[:NoExtract].split(" ").each  { |e|  @Alpm.alpm_option_add_noextract(e.strip.to_s)}   
      @options[:NoUpgrade].split(" ").each  { |e|  @Alpm.alpm_option_add_noupgrade(e.strip.to_s)}   
      
      $dbSync = @Alpm.alpm_option_get_syncdbs();
      $dbSync = @Alpm.alpm_list_first($dbSync);
    end
      
    #return a list of installed package
    def getLocalPkgs
      currPkg = @Alpm.alpm_db_getpkgcache($localDb)
      repo = @Alpm.alpm_db_get_name($localDb)
      while currPkg != nil
        pkg = @Alpm.alpm_list_getdata(currPkg)
        if block_given?
          pkgInfo=getPkgData(pkg,$localDb)
          #allPkgs = @Alpm.alpm_list_add(allPkgs,@Alpm.alpm_list_getdata(currPkgs));
          yield pkgInfo
        end  
        currPkg = @Alpm.alpm_list_next(currPkg)
      end
    end
    
    def getPkgData(pmpkgt,pmdbt)
      pkgInfo={:desk=>nil,:name=>nil,:version=>nil,:size=>nil,:repo=>nil}
      pkgInfo[:desc]=@Alpm.alpm_pkg_get_desc(pmpkgt)
      pkgInfo[:name]=@Alpm.alpm_pkg_get_name(pmpkgt)
      pkgInfo[:version]=@Alpm.alpm_pkg_get_version(pmpkgt)
      pkgInfo[:size]=@Alpm.alpm_pkg_get_size(pmpkgt)
      pkgInfo[:repo]=@Alpm.alpm_db_get_name(pmdbt) 
      return pkgInfo
    end
    
    #return a list of package on remote repository
    def getSyncPkgs
      
      dbSync = $dbSync
      allPkgs = nil;
      while dbSync != nil do
          currDb = @Alpm.alpm_list_getdata(dbSync);
          currPkgs = @Alpm.alpm_db_getpkgcache(currDb);
          pp @Alpm.alpm_db_get_name(currDb)
          while currPkgs != nil do
            pkg = @Alpm.alpm_list_getdata(currPkgs) 
            if block_given?
              pkgInfo=getPkgData(pkg,currDb)  
              yield pkgInfo
              #allPkgs = @Alpm.alpm_list_add(allPkgs,@Alpm.alpm_list_getdata(currPkgs));
            end
            currPkgs = @Alpm.alpm_list_next(currPkgs);
          end
          dbSync = @Alpm.alpm_list_next(dbSync);
      end
      return allPkgs;
      dbSync = @Alpm.alpm_list_first(dbSync)
    end
    
=begin    
    #return an hash 
    @listOnRepo = {"reponame"=>{"packagename"=> {
                                                  :desc => nil,
                                                  :version => nil,
                                                  :size => nil,
                                                  :repo => nil
                                      }
                           }
                  }
     
=end
    def createHashs()
      @package = {
            :desc => nil,
            :version => nil,
            :size => nil,
            :repo => nil
      }
       
      self.getSyncPkgs { |pkgInfo|
        pkgRepo=pkgInfo[:repo].to_s
        pkgName=pkgInfo[:name].to_s             
        if not @listOnRepo.include? pkgRepo
            @listOnRepo.store(pkgRepo,{})
        end
        
        @listOnRepo[pkgRepo].store(pkgName,pkgInfo)
        @listOnPkg.store(pkgName,pkgInfo.store(:installed,false)) 
      }
      
      self.getLocalPkgs { |pkgInfo|
        pkgRepo=pkgInfo[:repo].to_s
        pkgName=pkgInfo[:name].to_s             
                            
        if not @listOnRepo.include? pkgRepo
           @listOnRepo.store(pkgRepo,{})
        end
        @listOnRepo[pkgRepo].store(pkgName,pkgInfo)
        
        if @listOnPkg.include? pkgName    
          pp @listOnPkg
        end
        
      }
      return @listOnRepo,@listOnRepo
    end  
      
    def yamlSerialize(listOnRepo)
      File.open("listOnRepo.yaml", "w") { |file| 
        file.write(YAML::dump(listOnRepo)) }
    end                                  
    
    #return all pkg of a DB
    def getPkgsFromDb(db)
      dbPkgs = nil;
      currDb = nil;
      dbSync = $dbSync
      
      while dbSync != nil do
          currDb = @Alpm.alpm_list_getdata(dbSync);
          dbName = @Alpm.alpm_db_get_name(currDb);
          if(dbName == db)
              break;
          end
          dbSync = @Alpm.alpm_list_next(dbSync);
      end
      
      pkgs = @Alpm.alpm_db_getpkgcache(currDb);
      
      while pkgs != nil do
          current = @Alpm.alpm_list_getdata(pkgs);
          if block_given?
            yield current
          end
          dbPkgs = @Alpm.alpm_list_add(dbPkgs,current);
          pkgs = @Alpm.alpm_list_next(pkgs);
      end
      return dbPkgs;
    end
    
        
    ## Esiste la funzioni da libalpm 
    def getPkgFromName(namePkg)
      retPkg = nil;
      puts $dbSync
      dbSync = $dbSync
      currPkgs=nil   
      while (dbSync != nil) and (currPkgs==nil) do
          currDb = @Alpm.alpm_list_getdata(dbSync);
          currPkgs = @Alpm.alpm_get_get_pkg(currDb,namePkg) while currPkgs!=nil
          dbSync = @Alpm.alpm_list_next(dbSync);
      end            
      
      return @Alpm.alpm_list_getdata(currPkgs)
    end
=begin    
    def getPkgFromName(namePkg, nameDb)
      @retPkg = nil;
      @db = nil;
      $dbSync = @Alpm.alpm_list_first($dbSync);
      
      while ($dbSync != nil) do
	@db = @Alpm.alpm_list_getdata($dbSync);
	name = @Alpm.alpm_db_get_name(@db);
	if name == nameDb
	  break;
	end
	$dbSync = @Alpm.alpm_list_next($dbSync);
      end
      
      pkgs = @Alpm.alpm_db_getpkgcache(@db);
      while pkgs != nil do
	s = @Alpm.alpm_pkg_get_name(@Alpm.alpm_list_getdata(pkgs));
	if s == namePkg
	  @retPkg = @Alpm.alpm_list_getdata(pkgs);
	  return @retPkg
	end
	pkgs = @Alpm.alpm_list_next(pkgs);
      end
    end
=end 

  def isInstalled(namePkg)
      pkg = nil;
      pkg = @Alpm.alpm_db_get_pkg($localDb,namePkg);
      if pkg != nil
      return true
      else
          return false
      end
    end
    
    def getPkgSize(namePkg)
      return @Alpm.alpm_pkg_get_size(namePkg);
    end
    
    def getPkgProvide(namePkg)
      prov = Array.new;
      prov = [];
      
      pkg = self.getPkgFromName(namePkg);
      lst = @Alpm.alpm_pkg_get_provides(pkg);
      
      while lst != nil do
          prov << @Alpm.alpm_list_getdata(lst);
          lst = @Alpm.alpm_list_next(lst);
      end
      
      return prov;
    end
    
    def getPkgVer(namePkg)
      pkg = self.getPkgFromName(namePkg);
      return @Alpm.alpm_pkg_get_version(pkg);
    end
    
    def getPkgRepo(namePkg)
      dbSync = $dbSync
      db = nil;
      pkg = nil;
      
      while dbSync != nil do
          db = @Alpm.alpm_list_getdata(dbSync);
          pkg = @Alpm.alpm_db_get_pkg(db,namePkg);
          if pkg != nil
              return @Alpm.alpm_db_get_name(db);
          end
          dbSync = @Alpm.alpm_list_next(dbSync);
      end
    end
    
    def getUpPkg()
      upPkg = DL::PtrData.new(nil)
      #@upPkg = [nil,nil,nil].pack('ppp').to_ptr
      dbSync = $dbSync
      if ((@Alpm.alpm_sync_sysupgrade($localDb, dbSync, upPkg .ref)== -1))
          return "Error!"
      end
      upPkg = @Alpm.alpm_list_first(upPkg)
      return upPkg;
      
    end
    
    #Only for installed packages.....
    def getPkgFiles(pkgName)
      files = Array.new;
      files = [];
      
      lst = @Alpm.alpm_pkg_get_files(@Alpm.alpm_db_get_pkg($localDb, pkgName));
      while lst != nil  do
          files << @Alpm.alpm_list_getdata(lst);
          lst = @Alpm.alpm_list_next(lst);
      end
      return files;
    end
    
     def getGrps()
      grp = Array.new;
      grp = [];
      dbSync = $dbSync
      
      while dbSync != nil do
          group = @Alpm.alpm_db_getgrpcache(@Alpm.alpm_list_getdata(dbSync));
          while group != nil do
              grp << @Alpm.alpm_grp_get_name(@Alpm.alpm_list_getdata(group));
              group = @Alpm.alpm_list_next(group);
          end
          dbSync = @Alpm.alpm_list_next(dbSync);
      end
      
      return grp;
    end
    
    def getRequired(pkgName)
      deps = Array.new;
      deps = [];
      temp = nil;
      pkg=self.getPkgFromName(pkgName);
      
      temp = @Alpm.alpm_pkg_compute_requiredby(pkg);
      temp = @Alpm.alpm_list_first(temp);
      
      while temp != nil do
          deps << @Alpm.alpm_list_getdata(temp);
          temp = @Alpm.alpm_list_next(temp);
      end
      
      return deps;
    end
    
    def getPkgDeps(pkgName)
      deps = Array.new;
      deps = [];
      temp = nil;
      pkg=self.getPkgFromName(pkgName);
      temp = @Alpm.alpm_pkg_get_depends(pkg);
      temp = @Alpm.alpm_list_first(temp);
      while temp != nil do
          deps << @Alpm.alpm_pkg_get_name(@Alpm.alpm_list_getdata(temp))
          temp = @Alpm.alpm_list_next(temp)
      end
      
      return deps;
    end
    
    def close
      @Alpm.alpm_release();
    end
    
    def addToRemove(removes)
      $toRemove = removes
    end
    
    def addToInstall(installs)
      local = $localDb
      $toInstall = installs
    end
    
    def addFromFile(files)
      $toFIle = files      
    end
    
    def setupTrans(type, flag)
      #puts flag= PM_TRANS_FLAG_NOSCRIPTLET | PM_TRANS_FLAG_FORCE
      if (@Alpm.alpm_trans_init(type, flag, CALLBACK::CB_TRANS_EVT, CALLBACK::CB_TRANS_CONV, CALLBACK::CB_TRANS_PROGRESS) == -1)
        puts "Delete /var/lib/pacman/db.lck"
        return false
      end
      return true
    end
    
    def execTransaction()
       ret = DL::PtrData.new(nil)
          
       if @Alpm.alpm_trans_prepare(ret.ref) == -1
          puts "Could not prepare transcation"
          return false
       end
          
       if @Alpm.alpm_trans_commit(ret.ref) == -1
          puts "Could not commit transaction"
          return false        
       end
          
       #puts ret
       return true
    end
    
    def upDb()
      db = @Alpm.alpm_option_get_syncdbs
      if (not self.setupTrans(PM_TRANS_TYPE_SYNC,PM_TRANS_FLAG_NOSCRIPTLET))
        puts("Could not initialize sync trans.DB")
        break;
      end
      
      while db != nil
        dbCurr = @Alpm.alpm_list_getdata(db)
        
        ret = @Alpm.alpm_db_update(0,dbCurr)
        if ret <0
          puts("error on"+@Alpm.alpm_db_get_name(dbCurr))
        elsif ret == 1
            puts ("Synched to "+@Alpm.alpm_db_get_name(dbCurr))
        end
        db = @Alpm.alpm_list_next(db)
      end
      
      @Alpm.alpm_trans_release
    end
    
    def addTrans()
      #puts $toRemove
      if $toRemove.length > 0
          if(setupTrans(PM_TRANS_TYPE_REMOVE, PM_TRANS_FLAG_NOSCRIPTLET))
            #puts $toRemove
            $toRemove.each{ |pkg|
              if (@Alpm.alpm_trans_addtarget(pkg)) == -1
                puts "Cannot add target #{pkg}"
              end
            }
            self.execTransaction()
            @Alpm.alpm_trans_release
          end
      end
      
      if $toInstall.length > 0
          if (setupTrans(PM_TRANS_TYPE_SYNC, PM_TRANS_FLAG_NOSCRIPTLET))
              $toInstall.each{ |pkg|
                  if (@Alpm.alpm_trans_addtarget(pkg)) == -1
                    puts "Cannot add target #{pkg}"
                  end
              }
            self.execTransaction()
            @Alpm.alpm_trans_release         
          end        
      end
      
      if $toFile.length > 0
          if (setupTrans(PM_TRANS_TYPE_UPGRADE, PM_TRANS_FLAG_NOSCRIPTLET))
            $toFIle.each{ |pkg|
              if (@Alpm.alpm_trans_addtarget(pkg)) == -1
                  puts "Cannot add target #{pkg}"
              end
            }
            self.execTransaction()
            @Alpm.alpm_trans_release
          end        
      end
    end
  end
end