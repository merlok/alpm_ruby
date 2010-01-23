#This ruby lib is a porting of archlinux libalpm
#TODO implents Callbacks?!
#TODO test functions
#TODO testare i prototipi modificati (alcuni prototipi all'interno del header non erano funzioni puntate mentre per farle 
#     riconsere al ruby ho dovuto puntarle) 
#TODO implents alpm_list.h
#TODO search alias for time_t off_t and size_t
#FIXED size_t=unsigned int
#FIXED Callbacks
#TODO Implementig all callbacks and test all
#FIXED implement alpm_list.h
require 'dl'
require 'callback'
module ALPM
  
  class Funz
=begin
  Dichiarazione dei callback però nono sò se funzionano..... XD
=end


  
  #alpm_list.h
  #def my_alpm_list_fn_free(ptr1)
   # ptr1.ptr.to_s
  #end
  #def my_alpm_list_fn_cmp(ptr1,ptr2)
  #  ptr1.ptr.to_s <=> ptr2.ptr.to_s
  #end
  
  #ALPM_LIST_FN_FREE=callback "void my_alpm_list_fn_free(void *)"
  #ALPM_LIST_FN_CMP=callback"int my_alpm_list_fn_cmp(const void *, const void *)"
  
  #All the structure into libalpm
  #typealias("pmdb_t","__pmdb_t")
  #typealias("alpm_list_t","__alpm_list_t")
  #typealias("pmpkg_t","__pmpkg_t")
  #typealias("pmdelta_t","__pmdelta_t")
  #typealias("pmgrp_t","__pmgrp_t")
  #typealias("pmtrans_t","__pmtrans_t")
  #typealias("pmsyncpkg_t","__pmsyncpkg_t")
  #typealias("pmdepend_t","__pmdepend_t")
  #typealias("pmdepmissing_t","__pmdepmissing_t")
  #typealias("pmconflict_t","__pmconflict_t")
  #typealias("pmfileconflict_t","__pmfileconflict_t")
  #typealias("size_t","unsigned int")
  
  ##Enumerations
  #typealias("pmloglevel_t","_pmloglevel_t")
  #typealias("pmpkgreaon_t","_pmpkgreason_t")
  #typealias("pmtranstype_t","_pmtranstype_t")
  #typealias("pmtransflag_t","_pmtransflag_t")
  #typealias("pmtransalias_t","_pmtransalias_t")#flags
  #typealias("pmtransevt_t","_pmtransevt_t")
  #typealias("pmtransconv_t","_pmtransconv_t")
  #typealias("pmtransprog_t","_pmtransprog_t")
  #typealias("pmdepmod_t","_pmdepmod_t")
  #typealias("pmfileconflicttype_t","_pmfileconflicttype_t")
  #typealias("pmerrno_t","_pmerrno_t")
  
  LIB = DL.dlopen('/usr/lib/libalpm.so')
  
  
  #alpm.h
  SYM={
			:alpm_initialize => LIB['alpm_initialize','I'],
			:alpm_release => LIB['alpm_release','I'],
			:alpm_version => LIB['alpm_version','S'],
			:alpm_option_get_root => LIB['alpm_option_get_root','S'],
			:alpm_option_set_root => LIB['alpm_option_set_root','IS'],
			:alpm_option_get_dbpath => LIB['alpm_option_get_dbpath','S'],
			:alpm_option_set_dbpath => LIB['alpm_option_set_dbpath','IS'],
			:alpm_option_get_cachedirs => LIB['alpm_option_get_cachedirs','P'],
			:alpm_option_add_cachedir => LIB['alpm_option_add_cachedir','IS'],
			:alpm_option_set_cachedirs => LIB['alpm_option_set_cachedirs','0P'],
			:alpm_option_remove_cachedir => LIB['alpm_option_remove_cachedir','IS'],
			:alpm_option_get_logfile => LIB['alpm_option_get_logfile','S'],
			:alpm_option_set_logfile => LIB['alpm_option_set_logfile','IS'],
			:alpm_option_get_lockfile => LIB['alpm_option_get_lockfile','s'],
			:alpm_option_get_usesyslog => LIB['alpm_option_get_usesyslog','H'], #SHORT
			:alpm_option_set_usesyslog => LIB['alpm_option_set_usesyslog','0H'], #SHORT
			:alpm_option_get_noupgrades => LIB['alpm_option_get_noupgrades','P'],
			:alpm_option_add_noupgrade => LIB['alpm_option_add_noupgrade','0S'],
			:alpm_option_set_noupgrades => LIB['alpm_option_set_noupgrades','0P'],
			:alpm_option_remove_noupgrade => LIB['alpm_option_remove_noupgrade','IS'],
			:alpm_option_get_noextracts => LIB['alpm_option_get_noextracts','P'],
			:alpm_option_add_noextract => LIB['alpm_option_add_noextract','0S'],
			:alpm_option_set_noextracts => LIB['alpm_option_set_noextracts','0P'],
			:alpm_option_remove_noextract => LIB['alpm_option_remove_noextract','IS'],
			:alpm_option_get_ignorepkgs => LIB['alpm_option_get_ignorepkgs','P'],
			:alpm_option_add_ignorepkg => LIB['alpm_option_add_ignorepkg','0S'],
			:alpm_option_set_ignorepkgs => LIB['alpm_option_set_ignorepkgs','0P'],
			:alpm_option_remove_ignorepkg => LIB['alpm_option_remove_ignorepkg','IS'],
			:alpm_option_get_holdpkgs => LIB['alpm_option_get_holdpkgs','P'],
			:alpm_option_add_holdpkg => LIB['alpm_option_add_holdpkg','0S'],
			:alpm_option_set_holdpkgs => LIB['alpm_option_set_holdpkgs','0P'],
			:alpm_option_remove_holdpkg => LIB['alpm_option_remove_holdpkg','IS'],
			:alpm_option_get_ignoregrps => LIB['alpm_option_get_ignoregrps','P'],
			:alpm_option_add_ignoregrp => LIB['alpm_option_add_ignoregrp','0S'],
			:alpm_option_set_ignoregrps => LIB['alpm_option_set_ignoregrps','0P'],
			:alpm_option_remove_ignoregrp => LIB['alpm_option_remove_ignoregrp','IS'],
			:alpm_option_get_xfercommand => LIB['alpm_option_get_xfercommand','S'],
			:alpm_option_set_xfercommand => LIB['alpm_option_set_xfercommand','0S'],
			:alpm_option_get_nopassiveftp => LIB['alpm_option_get_nopassiveftp','H'], #SHORT
			:alpm_option_set_nopassiveftp => LIB['alpm_option_set_nopassiveftp','0H'], #SHORT
			:alpm_option_set_usedelta => LIB['alpm_option_set_usedelta','0H'], #SHORT
			:alpm_option_get_localdb => LIB['alpm_option_get_localdb','P'],
			:alpm_option_get_syncdbs => LIB['alpm_option_get_syncdbs','P'],
			:alpm_db_register_local => LIB['alpm_db_register_local','P'],
			:alpm_db_register_sync => LIB['alpm_db_register_sync','PS'],
			:alpm_db_unregister => LIB['alpm_db_unregister','IP'],
			:alpm_db_unregister_all => LIB['alpm_db_unregister_all','I'],
			:alpm_db_get_name => LIB['alpm_db_get_name','SP'], #const void*
			:alpm_db_get_url => LIB['alpm_db_get_url','SP'], #const void*
			:alpm_db_setserver => LIB['alpm_db_setserver','IPS'],
			:alpm_db_update => LIB['alpm_db_update','IIP'],
			:alpm_db_get_pkg => LIB['alpm_db_get_pkg','PPS'],
			:alpm_db_getpkgcache => LIB['alpm_db_getpkgcache','PP'],
			:alpm_db_readgrp => LIB['alpm_db_readgrp','PPc'],
			:alpm_db_getgrpcache => LIB['alpm_db_getgrpcache','PP'],
			:alpm_db_search => LIB['alpm_db_search','PPP'], #const void *
			:alpm_pkg_load => LIB['alpm_pkg_load','ISHP'], #SECONDA I SHORT
			:alpm_pkg_free => LIB['alpm_pkg_free','IP'],
			:alpm_pkg_checkmd5sum => LIB['alpm_pkg_checkmd5sum','IP'],
			:alpm_fetch_pkgurl => LIB['alpm_fetch_pkgurl','cS'],
			:alpm_pkg_vercmp => LIB['alpm_pkg_vercmp','ISS'],
			:alpm_pkg_compute_requiredby => LIB['alpm_pkg_compute_requiredby','PP'],
			:alpm_pkg_get_filename => LIB['alpm_pkg_get_filename','SP'],
			:alpm_pkg_get_name => LIB['alpm_pkg_get_name','SP'],
			:alpm_pkg_get_version => LIB['alpm_pkg_get_version','SP'],
			:alpm_pkg_get_desc => LIB['alpm_pkg_get_desc','SP'],
			:alpm_pkg_get_url => LIB['alpm_pkg_get_url','SP'], 
			:alpm_pkg_get_builddate => LIB['alpm_pkg_get_builddate','IP'],
			:alpm_pkg_get_installdate => LIB['alpm_pkg_get_installdate','IP'],
			:alpm_pkg_get_packager => LIB['alpm_pkg_get_packager','SP'],
			:alpm_pkg_get_md5sum => LIB['alpm_pkg_get_md5sum','SP'],
			:alpm_pkg_get_arch => LIB['alpm_pkg_get_arch','SP'],
			:alpm_pkg_get_size => LIB['alpm_pkg_get_size','LP'],
			:alpm_pkg_get_isize => LIB['alpm_pkg_get_isize','LP'],
			:alpm_pkg_get_reason => LIB['alpm_pkg_get_reason','PP'],
			:alpm_pkg_get_licenses => LIB['alpm_pkg_get_licenses','PP'],
			:alpm_pkg_get_groups => LIB['alpm_pkg_get_groups','PP'],
			:alpm_pkg_get_depends => LIB['alpm_pkg_get_depends','PP'],
			:alpm_pkg_get_optdepends => LIB['alpm_pkg_get_optdepends','PP'],
			:alpm_pkg_get_conflicts => LIB['alpm_pkg_get_conflicts','PP'],
			:alpm_pkg_get_provides => LIB['alpm_pkg_get_provides','PP'],
			:alpm_pkg_get_deltas => LIB['alpm_pkg_get_deltas','PP'],
			:alpm_pkg_get_replaces => LIB['alpm_pkg_get_replaces','PP'],
			:alpm_pkg_get_files => LIB['alpm_pkg_get_files','PP'],
			:alpm_pkg_get_backup => LIB['alpm_pkg_get_backup','PP'],
			:alpm_pkg_changelog_open => LIB['alpm_pkg_changelog_open','0P'],
			:alpm_pkg_changelog_read => LIB['alpm_pkg_changelog_read','IPIPP'], #Le ultime 2 P sono const
			:alpm_pkg_changelog_close => LIB['alpm_pkg_changelog_close','IPP'], #La seconda P � const
			:alpm_pkg_has_scriptlet => LIB['alpm_pkg_has_scriptlet','IP'], #LA I � SHORT
			:alpm_pkg_has_force => LIB['alpm_pkg_has_force','IP'], #LA I � SHORT
			:alpm_pkg_download_size => LIB['alpm_pkg_download_size','LP'],
			:alpm_delta_get_from => LIB['alpm_delta_get_from','SP'],
			:alpm_delta_get_from_md5sum => LIB['alpm_delta_get_from_md5sum','SP'],
			:alpm_delta_get_to => LIB['alpm_delta_get_to','SP'],
			:alpm_delta_get_to_md5sum => LIB['alpm_delta_get_to_md5sum','SP'],
			:alpm_delta_get_filename => LIB['alpm_delta_get_filename','SP'],
			:alpm_delta_get_md5sum => LIB['alpm_delta_get_md5sum','SP'],
			:alpm_delta_get_size => LIB['alpm_delta_get_size','LP'],
			:alpm_grp_get_name => LIB['alpm_grp_get_name','SP'], #P � costante
			:alpm_grp_get_pkgs => LIB['alpm_grp_get_pkgs','PP'], #la seconda P � costante
			:alpm_sync_get_pkg => LIB['alpm_sync_get_pkg','PP'], #la seconda P � costante 
			:alpm_sync_get_removes => LIB['alpm_sync_get_removes','PP'], #la seconda P � costante
			:alpm_sync_sysupgrade => LIB['alpm_sync_sysupgrade','IPPP'], #lultima P � doppiamente puntato 
			:alpm_trans_get_type => LIB['alpm_trans_get_type','P'], 
			:alpm_trans_get_flags => LIB['alpm_trans_get_flags','L'], #� un unsigned int
			:alpm_trans_get_pkgs => LIB['alpm_trans_get_pkgs','P'],
			:alpm_trans_init => LIB['alpm_trans_init','IIIPPP'],
			:alpm_trans_sysupgrade => LIB['alpm_trans_sysupgrade','I'],
			:alpm_trans_addtarget => LIB['alpm_trans_addtarget','Is'],
			:alpm_trans_prepare => LIB['alpm_trans_prepare','IP'], #P**
			:alpm_trans_commit => LIB['alpm_trans_commit','IP'], #P**
			:alpm_trans_interrupt => LIB['alpm_trans_interrupt','I'],
			:alpm_trans_release => LIB['alpm_trans_release','I'],
			:alpm_depcmp => LIB['alpm_depcmp','IPP'],
			:alpm_checkdeps => LIB['alpm_checkdeps','PPIPP'],
			:alpm_deptest => LIB['alpm_deptest','PPP'],
			:alpm_miss_get_target => LIB['alpm_miss_get_target','SP'], #const P
			:alpm_miss_get_dep => LIB['alpm_miss_get_dep','PP'],
			:alpm_miss_get_causingpkg => LIB['alpm_miss_get_causingpkg','SP'], #const P
			:alpm_checkdbconflicts => LIB['alpm_checkdbconflicts','PP'],
			:alpm_conflict_get_package1 => LIB['alpm_conflict_get_package1','SP'],
			:alpm_conflict_get_package2 => LIB['alpm_conflict_get_package2','SP'],
			:alpm_dep_get_mod => LIB['alpm_dep_get_mod','PP'], #seconda const P
			:alpm_dep_get_name => LIB['alpm_dep_get_name','SP'], #seconda const P
			:alpm_dep_get_version => LIB['alpm_dep_get_version','SP'], #seconda const P
			:alpm_dep_get_string => LIB['alpm_dep_get_string','cP'], #seconda const P
			:alpm_fileconflict_get_target => LIB['alpm_fileconflict_get_target','SP'],
			:alpm_fileconflict_get_type => LIB['alpm_fileconflict_get_type','PP'],
			:alpm_fileconflict_get_file => LIB['alpm_fileconflict_get_file','SP'],
			:alpm_fileconflict_get_ctarget => LIB['alpm_fileconflict_get_ctarget','SP'],
			:alpm_get_md5sum => LIB['alpm_get_md5sum','cS'],
			:alpm_strerror => LIB['alpm_strerror','SI'],
			:alpm_strerrorlast => LIB['alpm_strerrorlast','S'],
			:alpm_list_free => LIB['alpm_list_free','0P'],
			:alpm_list_free_inner => LIB['alpm_list_free_inner','0PP'], #C � IL CALLBACK ALPM_LIST_FN_FREE
			:alpm_list_add => LIB['alpm_list_add','PPP'], 
			:alpm_list_add_sorted => LIB['alpm_list_add_sorted','PPPP'],#DA CONTROLLARE + CALLBACK ALPM_LIST_FN_CMP
			:alpm_list_join => LIB['alpm_list_join','PPP'],
			:alpm_list_mmerge => LIB['alpm_list_mmerge','PPPP'],#ALPM_LIST_FN_CMP
			:alpm_list_msort => LIB['alpm_list_msort','PPIP'],#ALPM_LIST_FN_CMP
			:alpm_list_remove => LIB['alpm_list_remove','PPPPP'],#terza const P ultima P** + CALLBACK ALPM_LIST_FN_CMP
			:alpm_list_remove_str => LIB['alpm_list_remove_str','PPSP'], #Ultimo � un char**
			:alpm_list_remove_dupes => LIB['alpm_list_remove_dupes','PP'], #seconda const P
			:alpm_list_strdup => LIB['alpm_list_strdup','PP'], ##seconda const P
			:alpm_list_copy => LIB['alpm_list_copy','PP'], #seconda const P
			:alpm_list_copy_data => LIB['alpm_list_copy_data','PPL'], #seconda const P
			:alpm_list_reverse => LIB['alpm_list_reverse','PP'],
			:alpm_list_first => LIB['alpm_list_first','PP'], #seconda const P
			:alpm_list_nth => LIB['alpm_list_nth','PPI'], #seconda const P
			:alpm_list_next => LIB['alpm_list_next','PP'], #seconda const P
			:alpm_list_last => LIB['alpm_list_last','PP'], #seconda const P
			:alpm_list_getdata => LIB['alpm_list_getdata','PP'], #seconda const P
			:alpm_list_count => LIB['alpm_list_count','IP'], #const P
			:alpm_list_find => LIB['alpm_list_find','PPPP'], #seconda e terza const P CALLBACK ALPM_LIST_FN_CMP
			:alpm_list_find_ptr => LIB['alpm_list_find_ptr','PPP'], #seconda e terza const P
			:alpm_list_find_str => LIB['alpm_list_find_str','SPP'], #seconda e terza const P
			:alpm_list_diff => LIB['alpm_list_diff','PPPP'], #seconda e terza const P CALLBACK ALPM_LIST_FN_CMP
			#:cb_dl_total => LIB['cb_dl_total','L']
		}
  

	def alpm_initialize()
	    r,rs = SYM[:alpm_initialize].call()
	    return r
	end

	def alpm_release()
	    r,rs = SYM[:alpm_release].call()
	    return r
	end

	def alpm_version()
	    r,rs = SYM[:alpm_version].call()
	    return r
	end

	def alpm_option_get_root()
	    r,rs = SYM[:alpm_option_get_root].call()
	    return r
	end

	def alpm_option_set_root(param0)
	    r,rs = SYM[:alpm_option_set_root].call(param0)
	    return r
	end

	def alpm_option_get_dbpath()
	    r,rs = SYM[:alpm_option_get_dbpath].call()
	    return r
	end

	def alpm_option_set_dbpath(param0)
	    r,rs = SYM[:alpm_option_set_dbpath].call(param0)
	    return r
	end

	def alpm_option_get_cachedirs()
	    r,rs = SYM[:alpm_option_get_cachedirs].call()
	    return r
	end

	def alpm_option_add_cachedir(param0)
	    r,rs = SYM[:alpm_option_add_cachedir].call(param0)
	    return r
	end

	def alpm_option_set_cachedirs(param0)
	    r,rs = SYM[:alpm_option_set_cachedirs].call(param0)
	    return r
	end

	def alpm_option_remove_cachedir(param0)
	    r,rs = SYM[:alpm_option_remove_cachedir].call(param0)
	    return r
	end

	def alpm_option_get_logfile()
	    r,rs = SYM[:alpm_option_get_logfile].call()
	    return r
	end

	def alpm_option_set_logfile(param0)
	    r,rs = SYM[:alpm_option_set_logfile].call(param0)
	    return r
	end

	def alpm_option_get_lockfile()
	    r,rs = SYM[:alpm_option_get_lockfile].call()
	    return r
	end

	def alpm_option_get_usesyslog()
	    r,rs = SYM[:alpm_option_get_usesyslog].call()
	    return r
	end

	def alpm_option_set_usesyslog(param0)
	    r,rs = SYM[:alpm_option_set_usesyslog].call(param0)
	    return r
	end

	def alpm_option_get_noupgrades()
	    r,rs = SYM[:alpm_option_get_noupgrades].call()
	    return r
	end

	def alpm_option_add_noupgrade(param0)
	    r,rs = SYM[:alpm_option_add_noupgrade].call(param0)
	    return r
	end

	def alpm_option_set_noupgrades(param0)
	    r,rs = SYM[:alpm_option_set_noupgrades].call(param0)
	    return r
	end

	def alpm_option_remove_noupgrade(param0)
	    r,rs = SYM[:alpm_option_remove_noupgrade].call(param0)
	    return r
	end

	def alpm_option_get_noextracts()
	    r,rs = SYM[:alpm_option_get_noextracts].call()
	    return r
	end

	def alpm_option_add_noextract(param0)
	    r,rs = SYM[:alpm_option_add_noextract].call(param0)
	    return r
	end

	def alpm_option_set_noextracts(param0)
	    r,rs = SYM[:alpm_option_set_noextracts].call(param0)
	    return r
	end

	def alpm_option_remove_noextract(param0)
	    r,rs = SYM[:alpm_option_remove_noextract].call(param0)
	    return r
	end

	def alpm_option_get_ignorepkgs()
	    r,rs = SYM[:alpm_option_get_ignorepkgs].call()
	    return r
	end

	def alpm_option_add_ignorepkg(param0)
	    r,rs = SYM[:alpm_option_add_ignorepkg].call(param0)
	    return r
	end

	def alpm_option_set_ignorepkgs(param0)
	    r,rs = SYM[:alpm_option_set_ignorepkgs].call(param0)
	    return r
	end

	def alpm_option_remove_ignorepkg(param0)
	    r,rs = SYM[:alpm_option_remove_ignorepkg].call(param0)
	    return r
	end

	def alpm_option_get_holdpkgs()
	    r,rs = SYM[:alpm_option_get_holdpkgs].call()
	    return r
	end

	def alpm_option_add_holdpkg(param0)
	    r,rs = SYM[:alpm_option_add_holdpkg].call(param0)
	    return r
	end

	def alpm_option_set_holdpkgs(param0)
	    r,rs = SYM[:alpm_option_set_holdpkgs].call(param0)
	    return r
	end

	def alpm_option_remove_holdpkg(param0)
	    r,rs = SYM[:alpm_option_remove_holdpkg].call(param0)
	    return r
	end

	def alpm_option_get_ignoregrps()
	    r,rs = SYM[:alpm_option_get_ignoregrps].call()
	    return r
	end

	def alpm_option_add_ignoregrp(param0)
	    r,rs = SYM[:alpm_option_add_ignoregrp].call(param0)
	    return r
	end

	def alpm_option_set_ignoregrps(param0)
	    r,rs = SYM[:alpm_option_set_ignoregrps].call(param0)
	    return r
	end

	def alpm_option_remove_ignoregrp(param0)
	    r,rs = SYM[:alpm_option_remove_ignoregrp].call(param0)
	    return r
	end

	def alpm_option_get_xfercommand()
	    r,rs = SYM[:alpm_option_get_xfercommand].call()
	    return r
	end

	def alpm_option_set_xfercommand(param0)
	    r,rs = SYM[:alpm_option_set_xfercommand].call(param0)
	    return r
	end

	def alpm_option_get_nopassiveftp()
	    r,rs = SYM[:alpm_option_get_nopassiveftp].call()
	    return r
	end

	def alpm_option_set_nopassiveftp(param0)
	    r,rs = SYM[:alpm_option_set_nopassiveftp].call(param0)
	    return r
	end

	def alpm_option_set_usedelta(param0)
	    r,rs = SYM[:alpm_option_set_usedelta].call(param0)
	    return r
	end

	def alpm_option_get_localdb()
	    r,rs = SYM[:alpm_option_get_localdb].call()
	    return r
	end

	def alpm_option_get_syncdbs()
	    r,rs = SYM[:alpm_option_get_syncdbs].call()
	    return r
	end

	def alpm_db_register_local()
	    r,rs = SYM[:alpm_db_register_local].call()
	    return r
	end

	def alpm_db_register_sync(param0)
	    r,rs = SYM[:alpm_db_register_sync].call(param0)
	    return r
	end

	def alpm_db_unregister(param0)
	    r,rs = SYM[:alpm_db_unregister].call(param0)
	    return r
	end

	def alpm_db_unregister_all()
	    r,rs = SYM[:alpm_db_unregister_all].call()
	    return r
	end

	def alpm_db_get_name(param0)
	    r,rs = SYM[:alpm_db_get_name].call(param0)
	    return r
	end

	def alpm_db_get_url(param0)
	    r,rs = SYM[:alpm_db_get_url].call(param0)
	    return r
	end

	def alpm_db_setserver(param0,param1)
	    r,rs = SYM[:alpm_db_setserver].call(param0,param1)
	    return r
	end

	def alpm_db_update(param0,param1)
	    r,rs = SYM[:alpm_db_update].call(param0,param1)
	    return r
	end

	def alpm_db_get_pkg(param0,param1)
	    r,rs = SYM[:alpm_db_get_pkg].call(param0,param1)
	    return r
	end

	def alpm_db_getpkgcache(param0)
	    r,rs = SYM[:alpm_db_getpkgcache].call(param0)
	    return r
	end

	def alpm_db_readgrp(param0,param1)
	    r,rs = SYM[:alpm_db_readgrp].call(param0,param1)
	    return r
	end

	def alpm_db_getgrpcache(param0)
	    r,rs = SYM[:alpm_db_getgrpcache].call(param0)
	    return r
	end

	def alpm_db_search(param0,param1)
	    r,rs = SYM[:alpm_db_search].call(param0,param1)
	    return r
	end

	def alpm_pkg_load(param0,param1,param2)
	    r,rs = SYM[:alpm_pkg_load].call(param0,param1,param2)
	    return r
	end

	def alpm_pkg_free(param0)
	    r,rs = SYM[:alpm_pkg_free].call(param0)
	    return r
	end

	def alpm_pkg_checkmd5sum(param0)
	    r,rs = SYM[:alpm_pkg_checkmd5sum].call(param0)
	    return r
	end

	def alpm_fetch_pkgurl(param0)
	    r,rs = SYM[:alpm_fetch_pkgurl].call(param0)
	    return r
	end

	def alpm_pkg_vercmp(param0,param1)
	    r,rs = SYM[:alpm_pkg_vercmp].call(param0,param1)
	    return r
	end

	def alpm_pkg_compute_requiredby(param0)
	    r,rs = SYM[:alpm_pkg_compute_requiredby].call(param0)
	    return r
	end

	def alpm_pkg_get_filename(param0)
	    r,rs = SYM[:alpm_pkg_get_filename].call(param0)
	    return r
	end

	def alpm_pkg_get_name(param0)
	    r,rs = SYM[:alpm_pkg_get_name].call(param0)
	    return r
	end

	def alpm_pkg_get_version(param0)
	    r,rs = SYM[:alpm_pkg_get_version].call(param0)
	    return r
	end

	def alpm_pkg_get_desc(param0)
	    r,rs = SYM[:alpm_pkg_get_desc].call(param0)
	    return r
	end

	def alpm_pkg_get_url(param0)
	    r,rs = SYM[:alpm_pkg_get_url].call(param0)
	    return r
	end

	def alpm_pkg_get_builddate(param0)
	    r,rs = SYM[:alpm_pkg_get_builddate].call(param0)
	    return r
	end

	def alpm_pkg_get_installdate(param0)
	    r,rs = SYM[:alpm_pkg_get_installdate].call(param0)
	    return r
	end

	def alpm_pkg_get_packager(param0)
	    r,rs = SYM[:alpm_pkg_get_packager].call(param0)
	    return r
	end

	def alpm_pkg_get_md5sum(param0)
	    r,rs = SYM[:alpm_pkg_get_md5sum].call(param0)
	    return r
	end

	def alpm_pkg_get_arch(param0)
	    r,rs = SYM[:alpm_pkg_get_arch].call(param0)
	    return r
	end

	def alpm_pkg_get_size(param0)
	    r,rs = SYM[:alpm_pkg_get_size].call(param0)
	    return r
	end

	def alpm_pkg_get_isize(param0)
	    r,rs = SYM[:alpm_pkg_get_isize].call(param0)
	    return r
	end

	def alpm_pkg_get_reason(param0)
	    r,rs = SYM[:alpm_pkg_get_reason].call(param0)
	    return r
	end

	def alpm_pkg_get_licenses(param0)
	    r,rs = SYM[:alpm_pkg_get_licenses].call(param0)
	    return r
	end

	def alpm_pkg_get_groups(param0)
	    r,rs = SYM[:alpm_pkg_get_groups].call(param0)
	    return r
	end

	def alpm_pkg_get_depends(param0)
	    r,rs = SYM[:alpm_pkg_get_depends].call(param0)
	    return r
	end

	def alpm_pkg_get_optdepends(param0)
	    r,rs = SYM[:alpm_pkg_get_optdepends].call(param0)
	    return r
	end

	def alpm_pkg_get_conflicts(param0)
	    r,rs = SYM[:alpm_pkg_get_conflicts].call(param0)
	    return r
	end

	def alpm_pkg_get_provides(param0)
	    r,rs = SYM[:alpm_pkg_get_provides].call(param0)
	    return r
	end

	def alpm_pkg_get_deltas(param0)
	    r,rs = SYM[:alpm_pkg_get_deltas].call(param0)
	    return r
	end

	def alpm_pkg_get_replaces(param0)
	    r,rs = SYM[:alpm_pkg_get_replaces].call(param0)
	    return r
	end

	def alpm_pkg_get_files(param0)
	    r,rs = SYM[:alpm_pkg_get_files].call(param0)
	    return r
	end

	def alpm_pkg_get_backup(param0)
	    r,rs = SYM[:alpm_pkg_get_backup].call(param0)
	    return r
	end

	def alpm_pkg_changelog_open(param0)
	    r,rs = SYM[:alpm_pkg_changelog_open].call(param0)
	    return r
	end

	def alpm_pkg_changelog_read(param0,param1,param2,param3)
	    r,rs = SYM[:alpm_pkg_changelog_read].call(param0,param1,param2,param3)
	    return r
	end

	def alpm_pkg_changelog_close(param0,param1)
	    r,rs = SYM[:alpm_pkg_changelog_close].call(param0,param1)
	    return r
	end

	def alpm_pkg_has_scriptlet(param0)
	    r,rs = SYM[:alpm_pkg_has_scriptlet].call(param0)
	    return r
	end

	def alpm_pkg_has_force(param0)
	    r,rs = SYM[:alpm_pkg_has_force].call(param0)
	    return r
	end

	def alpm_pkg_download_size(param0)
	    r,rs = SYM[:alpm_pkg_download_size].call(param0)
	    return r
	end

	def alpm_delta_get_from(param0)
	    r,rs = SYM[:alpm_delta_get_from].call(param0)
	    return r
	end

	def alpm_delta_get_from_md5sum(param0)
	    r,rs = SYM[:alpm_delta_get_from_md5sum].call(param0)
	    return r
	end

	def alpm_delta_get_to(param0)
	    r,rs = SYM[:alpm_delta_get_to].call(param0)
	    return r
	end

	def alpm_delta_get_to_md5sum(param0)
	    r,rs = SYM[:alpm_delta_get_to_md5sum].call(param0)
	    return r
	end

	def alpm_delta_get_filename(param0)
	    r,rs = SYM[:alpm_delta_get_filename].call(param0)
	    return r
	end

	def alpm_delta_get_md5sum(param0)
	    r,rs = SYM[:alpm_delta_get_md5sum].call(param0)
	    return r
	end

	def alpm_delta_get_size(param0)
	    r,rs = SYM[:alpm_delta_get_size].call(param0)
	    return r
	end

	def alpm_grp_get_name(param0)
	    r,rs = SYM[:alpm_grp_get_name].call(param0)
	    return r
	end

	def alpm_grp_get_pkgs(param0)
	    r,rs = SYM[:alpm_grp_get_pkgs].call(param0)
	    return r
	end

	def alpm_sync_get_pkg(param0)
	    r,rs = SYM[:alpm_sync_get_pkg].call(param0)
	    return r
	end

	def alpm_sync_get_removes(param0)
	    r,rs = SYM[:alpm_sync_get_removes].call(param0)
	    return r
	end

	def alpm_sync_sysupgrade(param0,param1,param2)
	    r,rs ,r3,r4= SYM[:alpm_sync_sysupgrade].call(param0,param1,param2)
	    return r4
	end

	def alpm_trans_get_type()
	    r,rs = SYM[:alpm_trans_get_type].call()
	    return r
	end

	def alpm_trans_get_flags()
	    r,rs = SYM[:alpm_trans_get_flags].call()
	    return r
	end

	def alpm_trans_get_pkgs()
	    r,rs = SYM[:alpm_trans_get_pkgs].call()
	    return r
	end

	def alpm_trans_init(param0,param1,param2,param3,param4)
	    r,rs = SYM[:alpm_trans_init].call(param0, param1, CALLBACK::CB_TRANS_EVT, CALLBACK::CB_TRANS_CONV, CALLBACK::CB_TRANS_PROGRESS)
	    return r
	end

	def alpm_trans_sysupgrade()
	    r,rs = SYM[:alpm_trans_sysupgrade].call()
	    return r
	end

	def alpm_trans_addtarget(param0)
	    r,rs = SYM[:alpm_trans_addtarget].call(param0)
	    return r
	end

	def alpm_trans_prepare(param0)
	    r,rs = SYM[:alpm_trans_prepare].call(param0)
	    return r
	end

	def alpm_trans_commit(param0)
	    r,rs = SYM[:alpm_trans_commit].call(param0)
	    return r
	end

	def alpm_trans_interrupt()
	    r,rs = SYM[:alpm_trans_interrupt].call()
	    return r
	end

	def alpm_trans_release()
	    r,rs = SYM[:alpm_trans_release].call()
	    return r
	end

	def alpm_depcmp(param0,param1)
	    r,rs = SYM[:alpm_depcmp].call(param0,param1)
	    return r
	end

	def alpm_checkdeps(param0,param1,param2,param3)
	    r,rs = SYM[:alpm_checkdeps].call(param0,param1,param2,param3)
	    return r
	end

	def alpm_deptest(param0,param1)
	    r,rs = SYM[:alpm_deptest].call(param0,param1)
	    return r
	end

	def alpm_miss_get_target(param0)
	    r,rs = SYM[:alpm_miss_get_target].call(param0)
	    return r
	end

	def alpm_miss_get_dep(param0)
	    r,rs = SYM[:alpm_miss_get_dep].call(param0)
	    return r
	end

	def alpm_miss_get_causingpkg(param0)
	    r,rs = SYM[:alpm_miss_get_causingpkg].call(param0)
	    return r
	end

	def alpm_checkdbconflicts(param0)
	    r,rs = SYM[:alpm_checkdbconflicts].call(param0)
	    return r
	end

	def alpm_conflict_get_package1(param0)
	    r,rs = SYM[:alpm_conflict_get_package1].call(param0)
	    return r
	end

	def alpm_conflict_get_package2(param0)
	    r,rs = SYM[:alpm_conflict_get_package2].call(param0)
	    return r
	end

	def alpm_dep_get_mod(param0)
	    r,rs = SYM[:alpm_dep_get_mod].call(param0)
	    return r
	end

	def alpm_dep_get_name(param0)
	    r,rs = SYM[:alpm_dep_get_name].call(param0)
	    return r
	end

	def alpm_dep_get_version(param0)
	    r,rs = SYM[:alpm_dep_get_version].call(param0)
	    return r
	end

	def alpm_dep_get_string(param0)
	    r,rs = SYM[:alpm_dep_get_string].call(param0)
	    return r
	end

	def alpm_fileconflict_get_target(param0)
	    r,rs = SYM[:alpm_fileconflict_get_target].call(param0)
	    return r
	end

	def alpm_fileconflict_get_type(param0)
	    r,rs = SYM[:alpm_fileconflict_get_type].call(param0)
	    return r
	end

	def alpm_fileconflict_get_file(param0)
	    r,rs = SYM[:alpm_fileconflict_get_file].call(param0)
	    return r
	end

	def alpm_fileconflict_get_ctarget(param0)
	    r,rs = SYM[:alpm_fileconflict_get_ctarget].call(param0)
	    return r
	end

	def alpm_get_md5sum(param0)
	    r,rs = SYM[:alpm_get_md5sum].call(param0)
	    return r
	end

	def alpm_strerror(param0)
	    r,rs = SYM[:alpm_strerror].call(param0)
	    return r
	end

	def alpm_strerrorlast()
	    r,rs = SYM[:alpm_strerrorlast].call()
	    return r
	end

	def alpm_list_free(param0)
	    r,rs = SYM[:alpm_list_free].call(param0)
	    return r
	end

	def alpm_list_free_inner(param0,param1)
	    r,rs = SYM[:alpm_list_free_inner].call(param0,param1)
	    return r
	end

	def alpm_list_add(param0,param1)
	    r,rs = SYM[:alpm_list_add].call(param0,param1)
	    return r
	end

	def alpm_list_add_sorted(param0,param1,param2)
	    r,rs = SYM[:alpm_list_add_sorted].call(param0,param1,param2)
	    return r
	end

	def alpm_list_join(param0,param1)
	    r,rs = SYM[:alpm_list_join].call(param0,param1)
	    return r
	end

	def alpm_list_mmerge(param0,param1,param2)
	    r,rs = SYM[:alpm_list_mmerge].call(param0,param1,param2)
	    return r
	end

	def alpm_list_msort(param0,param1,param2)
	    r,rs = SYM[:alpm_list_msort].call(param0,param1,param2)
	    return r
	end

	def alpm_list_remove(param0,param1,param2,param3)
	    r,rs = SYM[:alpm_list_remove].call(param0,param1,param2,param3)
	    return r
	end

	def alpm_list_remove_str(param0,param1,param2)
	    r,rs = SYM[:alpm_list_remove_str].call(param0,param1,param2)
	    return r
	end

	def alpm_list_remove_dupes(param0)
	    r,rs = SYM[:alpm_list_remove_dupes].call(param0)
	    return r
	end

	def alpm_list_strdup(param0)
	    r,rs = SYM[:alpm_list_strdup].call(param0)
	    return r
	end

	def alpm_list_copy(param0)
	    r,rs = SYM[:alpm_list_copy].call(param0)
	    return r
	end

	def alpm_list_copy_data(param0,param1)
	    r,rs = SYM[:alpm_list_copy_data].call(param0,param1)
	    return r
	end

	def alpm_list_reverse(param0)
	    r,rs = SYM[:alpm_list_reverse].call(param0)
	    return r
	end

	def alpm_list_first(param0)
	    r,rs = SYM[:alpm_list_first].call(param0)
	    return r
	end

	def alpm_list_nth(param0,param1)
	    r,rs = SYM[:alpm_list_nth].call(param0,param1)
	    return r
	end

	def alpm_list_next(param0)
	    r,rs = SYM[:alpm_list_next].call(param0)
	    return r
	end

	def alpm_list_last(param0)
	    r,rs = SYM[:alpm_list_last].call(param0)
	    return r
	end

	def alpm_list_getdata(param0)
	    r,rs = SYM[:alpm_list_getdata].call(param0)
	    return r
	end

	def alpm_list_count(param0)
	    r,rs = SYM[:alpm_list_count].call(param0)
	    return r
	end

	def alpm_list_find(param0,param1,param2)
	    r,rs = SYM[:alpm_list_find].call(param0,param1,param2)
	    return r
	end

	def alpm_list_find_ptr(param0,param1)
	    r,rs = SYM[:alpm_list_find_ptr].call(param0,param1)
	    return r
	end

	def alpm_list_find_str(param0,param1)
	    r,rs = SYM[:alpm_list_find_str].call(param0,param1)
	    return r
	end

	def alpm_list_diff(param0,param1,param2)
	    r,rs = SYM[:alpm_list_diff].call(param0,param1,param2)
	    return r
	end

	#def cb_dl_total()
	#    r,rs = SYM[:cb_dl_total].call()
	#    return r
	#end
	end

end
