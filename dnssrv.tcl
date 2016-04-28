package require dns

namespace eval ::dnssrv {
	proc canonical {fqdn} {
		return $fqdn
	}

	proc resolve {qname _result} {
		upvar 1 $_result result
		unset -nocomplain result

		set dtok [::dns::resolve $qname -type SRV -class IN]
		::dns::wait $dtok
		set result [::dns::result $dtok]

		if {[::dns::status $dtok] eq "ok"} {
			set success 1
		} else {
			set success 0
		}

		::dns::cleanup $dtok

		return $success
	}

	proc sum_weightings {_weights} {
		upvar 1 $_weights weights

		set sum 0
		foreach h [array names weights] {
			incr sum $weights($h)
		}

		return $sum
	}

	proc pickhost {picked _worklist _retlist} {
		upvar 1 $_worklist worklist
		upvar 1 $_retlist retlist

		set newworklist [list]

		foreach h $worklist {
			if {$h eq $picked} {
				lappend retlist $h
			} else {
				lappend newworklist $h
			}
		}

		set worklist $newworklist

		return
	}

	proc apply_weightings {hostlist {_retlist retlist}} {
		upvar 1 $_retlist retlist

		# This behavior is defined by RFC2782

		set zero_weighted [list]
		set true_weighted [list]

		foreach h $hostlist {
			lassign $h weight target
			set weights($target) $weight

			if {$weight == 0} {
				lappend zero_weighted $target
			} else {
				lappend true_weighted $target
			}
		}

		set worklist [concat [randomize_list $zero_weighted] [randomize_list $true_weighted]]
		set retlist [list]

		while {1} {
			unset -nocomplain nexthost

			if {[llength $worklist] == 0} {
				break
			}

			set weightsum [sum_weightings weights]

			if {$weightsum == 0} {
				set nexthost [lindex $worklist 0]
			} else {
				set urn [expr { int(rand() * ($weightsum + 1))}]

				set running_sum 0

				for {set i 0} {$i < [llength $worklist]} {incr i} {
					set candidate_host [lindex $worklist $i]
					incr running_sum $weights($candidate_host)

					if {![info exists nexthost] && $running_sum >= $urn} {
						set nexthost $candidate_host
						break
					} else {
					}
				}
			}

			if {[info exists nexthost]} {
				pickhost $nexthost worklist retlist
				unset -nocomplain weights($nexthost)
			}
		}

		return
	}

	proc randomize_list {list} {
		set n [llength $list]
		for { set i 1 } { $i < $n } { incr i } {
			set j [expr { int( rand() * $n ) }]
			set temp [lindex $list $i]
			lset list $i [lindex $list $j]
			lset list $j $temp
		}
		return $list
	}

	proc hostlist {fqdn} {
		set retlist [list]

		set qname [::dnssrv::canonical $fqdn]

		::dnssrv::resolve $qname result

		foreach h $result {
			unset -nocomplain rdata host
			array set host $h
			array set rdata $host(rdata)

			lappend pri($rdata(priority)) [list $rdata(weight) $rdata(target)]
		}

		foreach priority [array names pri] {
			apply_weightings $pri($priority) retlist
		}

		return $retlist
	}

	proc tophost {fqdn} {
		return [lindex [::dnssrv::hostlist $fqdn] 0]
	}

}

package provide dnssrv 1.0
