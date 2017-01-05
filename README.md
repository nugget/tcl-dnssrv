[![GitHub
release](https://img.shields.io/github/release/nugget/tcl-dnssrv.svg)](https://github.com/nugget/tcl-dnssrv/releases)


# NAME

dnssrv - Tcl DNS SRV Client

# SYNOPSIS


````
package require dnssrv

::dnssrv::hostlist query ?options?
::dnssrv::tophost query ?options?
````

# DESCRIPTION

The dnssrv package provides a Tcl client for querying DNS SRV records.  You
should refer to RFC 2782 for information about DNS SRV records.

# COMMANDS

## ::dnssrv::hostlist query ?options?

Return an ordered list of hostnames from a DNS SRV RR recordset resolved
from DNS.  Query should be a fully qualified domain name in the form expected
for a DNS SRV record resembling `_service._protocol.example.org`

The list will be properly sorted and randomized to accommodate the advertised
priority and weighting values from the underlying RR recordset in DNS.

The `-ports` option will append the advertised port number as part of the hostname in the
form `hostname.example.org:port`

## ::dnssrv::tophost query ?options?

Returns a single hostname which represents the top-ordered host from the
hostlist for use where only a single hostname is desired.

# AUTHOR

David McNett - https://github.com/nugget/tcl-dnssrv
