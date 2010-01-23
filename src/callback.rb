require 'dl/struct'
require 'dl/import'
require 'dl'
module CALLBACK
extend DL::Importable
DL.dlopen("/usr/lib/libalpm.so")
$rate_last
$xfered_last
$list_xfered =0.0
$list_total=0.0
=begin
$initial_time=Timeval.malloc
Timeval=DL::Struct.struct [
	"long tv_sec",
	"long tv_usec" 
	]
=end


UPDATE_SPEED_SEC=0.2

$prevpercent=0
$on_progress = 0
output = DL::PtrData.new(nil) #alpm_list_t


	
=begin
def get_update_timediff(first_call)
	retval=0.0
	@last_time =Timeval.malloc
	@last_time.free=DL::FREE
	if (first_call)
		current=Time.now
		@last_time.tv_sec=current.tv_sec
		@last_time.tv_usec=current.tv_usec
	else
		this_time = Timeval.malloc
		diff_sec=0.0
		diff_usec=0.0
		current=Time.now
		this_time.tv_sec=current.tv_sec
		this_time.tv_usec=current.tv_usec
		
		diff_sec = this_time.tv_sec - @last_time.tv_sec
		diff_usec = this_time.tv_usec - @last_time.tv_usec
		
		retval=diff_sec+( diff_usec / 1000000.0);
		
		if (retval < UPDATE_SPEED_SEC) 
			retval=0.0
		else
			@last_time=this_time
		end
	end
	return retval
end
=end


=begin
/* callback to handle messages/notifications from libalpm transactions */
void cb_trans_evt(pmtransevt_t event, void *data1, void *data2)
{
	switch(event) {
		case PM_TRANS_EVT_CHECKDEPS_START:
		  printf(_("checking dependencies...\n"));
			break;
		case PM_TRANS_EVT_FILECONFLICTS_START:
			if(config->noprogressbar) {
			printf(_("checking for file conflicts...\n"));
			}
			break;
		case PM_TRANS_EVT_RESOLVEDEPS_START:
			printf(_("resolving dependencies...\n"));
			break;
		case PM_TRANS_EVT_INTERCONFLICTS_START:
			printf(_("looking for inter-conflicts...\n"));
			break;
		case PM_TRANS_EVT_ADD_START:
			if(config->noprogressbar) {
				printf(_("installing %s...\n"), alpm_pkg_get_name(data1));
			}
			break;
		case PM_TRANS_EVT_ADD_DONE:
			alpm_logaction("installed %s (%s)\n",
			         alpm_pkg_get_name(data1),
			         alpm_pkg_get_version(data1));
			display_optdepends(data1);
			break;
		case PM_TRANS_EVT_REMOVE_START:
			if(config->noprogressbar) {
			printf(_("removing %s...\n"), alpm_pkg_get_name(data1));
			}
			break;
		case PM_TRANS_EVT_REMOVE_DONE:
			alpm_logaction("removed %s (%s)\n",
			         alpm_pkg_get_name(data1),
			         alpm_pkg_get_version(data1));
			break;
		case PM_TRANS_EVT_UPGRADE_START:
			if(config->noprogressbar) {
				printf(_("upgrading %s...\n"), alpm_pkg_get_name(data1));
			}
			break;
		case PM_TRANS_EVT_UPGRADE_DONE:
			alpm_logaction("upgraded %s (%s -> %s)\n",
			         (char *)alpm_pkg_get_name(data1),
			         (char *)alpm_pkg_get_version(data2),
			         (char *)alpm_pkg_get_version(data1));
			display_optdepends(data1);
			break;
		case PM_TRANS_EVT_INTEGRITY_START:
			printf(_("checking package integrity...\n"));
			break;
		case PM_TRANS_EVT_DELTA_INTEGRITY_START:
			printf(_("checking delta integrity...\n"));
			break;
		case PM_TRANS_EVT_DELTA_PATCHES_START:
			printf(_("applying deltas...\n"));
			break;
		case PM_TRANS_EVT_DELTA_PATCH_START:
			printf(_("generating %s with %s... "), (char *)data1, (char *)data2);
			break;
		case PM_TRANS_EVT_DELTA_PATCH_DONE:
			printf(_("success!\n"));
			break;
		case PM_TRANS_EVT_DELTA_PATCH_FAILED:
			printf(_("failed.\n"));
			break;
		case PM_TRANS_EVT_SCRIPTLET_INFO:
			printf("%s", (char*)data1);
			break;
		case PM_TRANS_EVT_PRINTURI:
			printf("%s/%s\n", (char*)data1, (char*)data2);
			break;
		case PM_TRANS_EVT_RETRIEVE_START:
			printf(_(":: Retrieving packages from %s...\n"), (char*)data1);
			break;
		/* all the simple done events, with fallthrough for each */
		case PM_TRANS_EVT_FILECONFLICTS_DONE:
		case PM_TRANS_EVT_CHECKDEPS_DONE:
		case PM_TRANS_EVT_RESOLVEDEPS_DONE:
		case PM_TRANS_EVT_INTERCONFLICTS_DONE:
		case PM_TRANS_EVT_INTEGRITY_DONE:
		case PM_TRANS_EVT_DELTA_INTEGRITY_DONE:
		case PM_TRANS_EVT_DELTA_PATCHES_DONE:
			/* nothing */
			break;
	}
	fflush(stdout);
}
=end

def cb_trans_evt(event,data1,data2)
  
end

CB_TRANS_EVT = callback "void *cb_trans_evt(int,void *,void *)"

=begin
/* callback to handle questions from libalpm transactions (yes/no) */
/* TODO this is one of the worst ever functions written. void *data ? wtf */
void cb_trans_conv(pmtransconv_t event, void *data1, void *data2,
                   void *data3, int *response)
{
	switch(event) {
		case PM_TRANS_CONV_INSTALL_IGNOREPKG:
			if(data2) {
				/* TODO we take this route based on data2 being not null? WTF */
				*response = yesno(1, _(":: %s requires installing %s from IgnorePkg/IgnoreGroup. Install anyway?"),
						alpm_pkg_get_name(data2),
						alpm_pkg_get_name(data1));
			} else {
				*response = yesno(1, _(":: %s is in IgnorePkg/IgnoreGroup. Install anyway?"),
						alpm_pkg_get_name(data1));
			}
			break;
		case PM_TRANS_CONV_REMOVE_HOLDPKG:
			*response = yesno(1, _(":: %s is designated as a HoldPkg. Remove anyway?"),
					alpm_pkg_get_name(data1));
			break;
		case PM_TRANS_CONV_REPLACE_PKG:
			*response = yesno(1, _(":: Replace %s with %s/%s?"),
					alpm_pkg_get_name(data1),
					(char *)data3,
					alpm_pkg_get_name(data2));
			break;
		case PM_TRANS_CONV_CONFLICT_PKG:
			*response = yesno(1, _(":: %s conflicts with %s. Remove %s?"),
					(char *)data1,
					(char *)data2,
					(char *)data2);
			break;
		case PM_TRANS_CONV_LOCAL_NEWER:
			if(!config->op_s_downloadonly) {
				*response = yesno(1, _(":: %s-%s: local version is newer. Upgrade anyway?"),
						alpm_pkg_get_name(data1),
						alpm_pkg_get_version(data1));
			} else {
				*response = 1;
			}
			break;
		case PM_TRANS_CONV_CORRUPTED_PKG:
			*response = yesno(1, _(":: File %s is corrupted. Do you want to delete it?"),
					(char *)data1);
			break;
	}
}
=end

def cb_trans_conv(event,data1,data2,data3,response)
end

CB_TRANS_CONV = callback"void *cb_trans_conv(int,void *,void *,int *)"


=begin
/* callback to handle display of transaction progress */
void cb_trans_progress(pmtransprog_t event, const char *pkgname, int percent,
                       int howmany, int remain)
{
	float timediff;

	/* size of line to allocate for text printing (e.g. not progressbar) */
	const int infolen = 50;
	int tmp, digits, textlen;
	char *opr = NULL;
	/* used for wide character width determination and printing */
	int len, wclen, wcwid, padwid;
	wchar_t *wcstr;

	if(config->noprogressbar) {
		return;
	}

	if(percent == 0) {
		timediff = get_update_timediff(1);
	} else {
		timediff = get_update_timediff(0);
	}

	if(percent > 0 && percent < 100 && !timediff) {
		/* only update the progress bar when
		 * a) we first start
		 * b) we end the progress
		 * c) it has been long enough since the last call
		 */
		return;
	}

	/* if no pkgname, percent is too high or unchanged, then return */
	if(!pkgname || percent == prevpercent) {
		return;
	}

	prevpercent=percent;
	/* set text of message to display */
	switch (event) {
		case PM_TRANS_PROGRESS_ADD_START:
			opr = _("installing");
			break;
		case PM_TRANS_PROGRESS_UPGRADE_START:
			opr = _("upgrading");
			break;
		case PM_TRANS_PROGRESS_REMOVE_START:
			opr = _("removing");
			break;
		case PM_TRANS_PROGRESS_CONFLICTS_START:
			opr = _("checking for file conflicts");
			break;
	}

	/* find # of digits in package counts to scale output */
	digits = 1;
	tmp = howmany;
	while((tmp /= 10)) {
		++digits;
	}
	/* determine room left for non-digits text [not ( 1/12) part] */
	textlen = infolen - 3 - (2 * digits);

	/* In order to deal with characters from all locales, we have to worry
	 * about wide characters and their column widths. A lot of stuff is
	 * done here to figure out the actual number of screen columns used
	 * by the output, and then pad it accordingly so we fill the terminal.
	 */
	/* len = opr len + pkgname len (if available) + space  + null */
	len = strlen(opr) + ((pkgname) ? strlen(pkgname) : 0) + 2;
	wcstr = calloc(len, sizeof(wchar_t));
	/* print our strings to the alloc'ed memory */
#if defined(HAVE_SWPRINTF)
	wclen = swprintf(wcstr, len, L"%s %s", opr, pkgname);
#else
	/* because the format string was simple, we can easily do this without
	 * using swprintf, although it is probably not as safe/fast. The max
	 * chars we can copy is decremented each time by subtracting the length
	 * of the already printed/copied wide char string. */
	wclen = mbstowcs(wcstr, opr, len);
	wclen += mbstowcs(wcstr + wclen, " ", len - wclen);
	wclen += mbstowcs(wcstr + wclen, pkgname, len - wclen);
#endif
	wcwid = wcswidth(wcstr, wclen);
	padwid = textlen - wcwid;
	/* if padwid is < 0, we need to trim the string so padwid = 0 */
	if(padwid < 0) {
		int i = textlen - 3;
		wchar_t *p = wcstr;
		/* grab the max number of char columns we can fill */
		while(i > 0 && wcwidth(*p) < i) {
			i -= wcwidth(*p);
			p++;
		}
		/* then add the ellipsis and fill out any extra padding */
		wcscpy(p, L"...");
		padwid = i;

	}

	printf("(%*d/%*d) %ls%-*s", digits, remain, digits, howmany,
			wcstr, padwid, "");

	free(wcstr);

	/* call refactored fill progress function */
	fill_progress(percent, percent, getcols() - infolen);

	if(percent == 100) {
		alpm_list_t *i = NULL;
		on_progress = 0;
		for(i = output; i; i = i->next) {
			printf("%s", (char *)i->data);
		}
		fflush(stdout);
		FREELIST(output);
	} else {
		on_progress = 1;
	}
}
=end
def cb_trans_progress(event,pkgname,percent,howmany,remain)
end

CB_TRANS_PROGRESS = callback"void *cb_trans_progress(int,const char *,int,int,int)"


def cb_dl_total(total)

	$list_total = total
	
	if (total == 0) 
		$list_xfered = 0
	end
end
end