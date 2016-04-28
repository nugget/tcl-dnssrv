#!/usr/bin/env tclsh

source dnssrv.tcl

proc main {} {
	lappend hostlist _sweighted._tcp.prod.macnugget.org
	lappend hostlist _controlstream._tcp.prod.macnugget.org
	lappend hostlist _testservice._tcp.prod.macnugget.org

	foreach fqdn $hostlist {
		puts "\[::dnssrv::hostlist $fqdn\]"
		puts "  [::dnssrv::hostlist $fqdn]"
		puts "\[::dnssrv::tophost $fqdn\]"
		puts "  [::dnssrv::tophost $fqdn]"
		puts "-- "
	}
}

if !$tcl_interactive main
