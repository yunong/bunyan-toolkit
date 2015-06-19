#!/bin/bash
set -o nounset
set -o pipefail

# potential arguments
BUNYAN=bunyan
HEADER=
LATENCY=
LOG=
METHOD=
STATUS=
URL=

# bunyan oneliners
url=
method=
latency=
header=
statusCode=


NO_ARGS=0
E_OPTERROR=85

function usage {
        cat <<-END >&2
        USAGE: btkit [-dh] [-u url] [-m HTTP verb] [-H req header] [-l latency] [-s HTTP status code] logfile
                         -
                         -H req header   # request header to match against
                         -d              # turn on debug mode
                         -h              # this usage message
                         -l miliseconds  # find all requests that take longer than this
                         -m HTTP verb    # HTTP verb, e.g. GET, PUT to match against
                         -s status code  # find all requests with this HTTP status code
                         -u url          # URL to match against

           eg,
               btkit -u browse -l 1000 shakti.log
                                         # find all requests that took longer than 1000 miliseconds with a url containing browse
               btkit -u browse -l 1000 -s 500 shakti.log
                                         # find all requests that took longer than 1000 miliseconds with a url containing browse and a status code of 500
        See bunyan -h for more info.
END
exit $1
}

if [ $# -eq "$NO_ARGS" ]    # Script invoked with no command-line args?
then
    usage
    exit $E_OPTERROR          # Exit and explain usage.
fi

# Arguments
# d -- debug mode
# u -- parse for a particular url
# m -- http method
# H -- request header
# h -- help
# l -- look for requests longer than this latency
# s -- the status code of the request
# r -- look for a request with this uuid
while getopts ":dhu:m:H:l:s:" Option
do
    case $Option in
        d ) set -o xtrace;;
        u ) URL=$OPTARG;;
        m ) METHOD=$OPTARG;;
        H ) HEADER=$OPTARG;;
        h ) usage; exit ;;
        l ) LATENCY=$OPTARG;;
        s ) STATUS=$OPTARG;;
        r ) REQ_ID=$OPTARG;;
    esac
done

shift $(($OPTIND - 1))
(( $# )) || usage $E_OPTERROR


trap ':' INT QUIT TERM PIPE HUP

LOG=$1

cmd="grep restify-audit $LOG"
url="$BUNYAN -c 'this.req.url.indexOf(\"$URL\") !== -1' -0"
method="$BUNYAN -c 'this.req.method === \"$METHOD\"' -0"
latency="$BUNYAN -c 'this.latency > $LATENCY' -0"
header="$BUNYAN -c 'this.req.headers[\"$HEADER\"]' -0"
statusCode="$BUNYAN -c 'this.res.statusCode === $STATUS' -0"

if [ -n "$HEADER" ]
then
    cmd="$cmd | $header"
fi

if [ -n "$METHOD" ]
then
    cmd="$cmd | $method"
fi

if [ -n "$LATENCY" ]
then
    cmd="$cmd | $latency"
fi

if [ -n "$STATUS" ]
then
    cmd="$cmd | $statusCode"
fi

if [ -n "$URL" ]
then
    cmd="$cmd | $url"
fi

# have ot alias the command here to avoid bash inlining quotes around | and "
alias run=$cmd
shopt -s expand_aliases
run
