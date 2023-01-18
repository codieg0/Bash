#!/bin/bash

#Created by Diego Castro
# Help in r/bash 

#OPTIONS FOR THE SCRIPT

usage()
{
	# Display Help
	cat <<-'HelpDoc'
	This script will run the records for any domains.

	Syntax: ./records.sh [-h|d|s|a|m] [-S]
	Options:
	h	Prints Help section.
	d	Argument for DMARC record.
	s	Argument for SPF record.
	a	Argument for A record.
	m	Argument for MX record.
	S	+short

	HelpDoc
}

# We don't call the read command anymore as we will get the domain previously.

# The function DMARC() calls dig to extract the DMARC info.
# arg $1 is the record to query - domain.
# arg $2 is either +short or +noshort.

dmarc(){
	#read -p "Domain: " dmarcDomain
	echo "----------------------------------"
    dig txt "_dmarc.${1}" "$2"
    echo "----------------------------------"
}

# The function SPF() calls dig to extract the SPF info.
# arg $1 is the record to query - domain.
# There is no arg $2 as I am already pipping (|) and grepping just spf in that query.

spf(){
	#read -p "Domain: " spfDomain
	echo "----------------------------------"
	dig txt "$1" "$2" | grep -i spf
    echo "----------------------------------"
}

# The function ARECORD() calls dig to extract the A record info.
# arg $1 is the record to query - domain.
# arg $2 is either +short or +noshort.

arecord(){
	#read -p "Domain: " aRecordDomain
	echo "-----------------"
	dig A "$1" "$2"
	echo "-----------------"
}

# The function MX() calls dig to extract the MX record info
# arg $1 is the record to query - domain
# arg $2 is either +short or +noshort

mx(){
    #read -p "Domain: " mxDomain
    echo "-----------------"
    dig mx "$1" "$2"
	echo "-----------------"
}

##########
#PROCESS()#
##########

# The function process calls one of the dig functions.
# arg $1 is the function to be called.
# arg $2 is the record to query - that would be for the domain.
# arg $3 is either +short or +noshort.

# SPF won't call short becuase we are pipe and grep it.

process()
{
    case "$1" in
    dmarc)
            dmarc "$2" "$3"
        ;;
    spf)
            spf "$2" "$3"
        ;;
    arecord)
            arecord "$2" "$3"
        ;;
    mx)
            mx "$2" "$3"
        ;;
    *)
            dig "$2" "$3"
        ;;
    esac
}

#######
#+short#
#######

# $short is used to decide if a long or short record should be returned.
# We set it to either "+short" or "+noshort". By default, it is set to "+noshort"

short="+noshort"

#########
#GETOPTS#
#########

# This will give us the options to run with the script.

while getopts 'hdsamS' OPTION; 
do
	case "$OPTION" in
		h) # If -h is passed; it will show the usage of the script
			usage
			exit 0 # exit with success because this is not an error
			;;
		d)	# If -d is passed, we are looking for dmarc info
			action=dmarc
			;;
		s)	# If -s is passed, we want to look as spf info
			action=spf
			;;
		a)	# If -a is passed, we want to look as a record info
			action=arecord
			;;
		m)	# If -m is passed, we want to look at mx records
			action=mx
			;;
		S)	# if -S is passed we want short versions
			short='+short'
			;;
		\?)
            usage  # Anythign else is an error show usage
            exit 1   # and exit with an error code
        	;;
	esac
done

# Tidy up "${@}" so that we just have a list of items to query

# The shift command is used to modify the list of positional parameters in $@ (all parameters passed to the script). This is the standard way to 'eat up' the positional parameters that have already been processed with getopts so that we can do something else with all the rest. Thre reason is to skip the options that have been parsed by getops and to leave the arguments available for further processing.

# shift removes positional parameters. In your case it removes optint-1 parameters.

# $((...)) just calculates stuff. In your case it takes the value of $optint and substracts 1.

shift "$((OPTIND - 1 ))"

# At this point "$@" contains the rest of the arguments

# For every item left in "$@" we want to perform the appropriate action using 'process'

for domain in "$@" ; do
    process "$action" "$domain" "$short"
done
