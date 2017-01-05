#!/usr/bin/env tclsh

if {[catch {source dnssrv.tcl} err]} {
	package require dnssrv
}

proc main {} {
	lappend hostlist _sweighted._tcp.prod.macnugget.org
	lappend hostlist _weighted._tcp.prod.macnugget.org
	lappend hostlist _testservice._tcp.prod.macnugget.org

	foreach fqdn $hostlist {
		puts "# Probing ${fqdn}\n"
		puts "  \[::dnssrv::hostlist $fqdn\]"
		puts "    [::dnssrv::hostlist $fqdn]"
		puts ""
		puts "  \[::dnssrv::tophost $fqdn\]"
		puts "    [::dnssrv::tophost $fqdn]"
		puts "\n-- \n"
	}
}

if !$tcl_interactive main
