#!/usr/bin/env tclsh

source dnssrv.tcl

proc main {} {
	lappend hostlist _sweighted._tcp.prod.macnugget.org
	lappend hostlist _controlstream._tcp.prod.macnugget.org
	lappend hostlist _testservice._tcp.prod.macnugget.org

	foreach fqdn $hostlist {
		puts "FQDN $fqdn"
		puts "  hostlist [::dnssrv::hostlist $fqdn]"
		puts "  tophost  [::dnssrv::tophost $fqdn]"
		puts "-- "
	}
}

if !$tcl_interactive main
