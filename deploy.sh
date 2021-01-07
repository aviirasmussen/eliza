#!/bin/bash
# read in environment
source .env
# sudo -u harry ./deploy.sh
# set -x
SRCDIR=./src
WORKDIR=./data
SCRIPT=script
LIB=lib
DB=db
TEMPLATES=templates
LOG=log

#ID=$(id -u harry)
#if [ $ID -ne $UID ]; then
#    echo "ERROR: Wrong ID[$ID] for deploy. Need harry[$ID]"
#    usage
#fi

function usage {
    echo "USAGE: ./deploy.sh --all|-a or --plans|-p [domain] or --lib|-l <lib>"
    echo "--all|-a deploys everything to $WORKDIR from $SRCDIR/$DB,$SRCDIR/$LIB,$SRCDIR/$SCRIPT,$SRCDIR/$TEMPLATES including configurations files"
    echo "--lib|-l <lib> deploy the specified $SRCDIR/$LIB/<lib> to $WORKDIR/$LIB/<lib>"
    echo "--plans|-p <domain> deploys all plans from $SRCDIR/$TEMPLATES/<domain> to $WORKDIR/$TEMPLATES<domain> if <domain> is specified, else all plans gets deployed"
    exit 1;
}


function deploy_all {
    # create if not there
    [[ -d $WORKDIR ]]            || mkdir $WORKDIR
    [[ -d $WORKDIR/$SCRIPT ]]    || mkdir $WORKDIR/$SCRIPT
    [[ -d $WORKDIR/$LIB ]]       || mkdir $WORKDIR/$LIB
    [[ -d $WORKDIR/$DB ]]        || mkdir $WORKDIR/$DB
    [[ -d $WORKDIR/$TEMPLATES ]] || mkdir $WORKDIR/$TEMPLATES
    [[ -d $WORKDIR/$LOG ]]       || mkdir $WORKDIR/$LOG
    # rsync preserve recursive, remove empty directories
    # script
    rsync -am --include="*/" --include="*.pl" --include="start.sh" --include="botlord" --include="*.me" --exclude="*" $SRCDIR/$SCRIPT $WORKDIR/
    # lib
    rsync -am --include="*/" --include="*.pm" --exclude="*" $SRCDIR/$LIB $WORKDIR/
    # Mojolicious configuration, secrets, tokens, ..
    rsync -am --include="botlord.conf" --exclude="*" $SRCDIR/ $WORKDIR/
    # dialog rulesets
    rsync -am --include="*/" --include="*.dialog" --include="*.plan" --exclude="*" $SRCDIR/$TEMPLATES $WORKDIR/
    # media for rulesets
    rsync -am --include="*/" --include="*.gif" --include="*.ico" --include="*.jpg"  --include="*.pdf" --include="*.png" --include="*.mp4" --exclude="*" $SRCDIR/$TEMPLATES $WORKDIR/
    # html elements for rulesets
    rsync -am --include="*.css" --include="*.js" --include="*.htm" --include="*.html" --exclude="*" $SRCDIR/$TEMPLATES $WORKDIR/
    # keys(secrets) and bot plan for domains under templates
    rsync -am --include="*/" --include="azure.keys" --include="bots.plan" --exclude="*" $SRCDIR/$DB $WORKDIR/
    # log configuration
    cp $SRCDIR/$DB/$RTE-log4perl.conf $WORKDIR/$DB/log4perl.conf
    echo "deploy all completed under $WORKDIR"
}
# all plans under all domains or plans under a domain
function deploy_plans {
    domain="$1"

    PLANDIR="$SRCDIR/$TEMPLATES"
    if [  $# -gt 0 ]; then
	PLANDIR="$PLANDIR/$domain"
    fi
    if ! [[ -d $PLANDIR ]]; then
	echo "ERROR: Directory [$PLANDIR] does not exists for domain=$domain!"
	exit 1;
    fi
    [[ -d $WORKDIR/$TEMPLATES ]] || mkdir $WORKDIR/$TEMPLATES
    # dialog rulesets
    rsync -am --include="*/" --include="*.dialog" --include="*.plan" --exclude="*" $SRCDIR/$TEMPLATES $WORKDIR/
    # media for rulesets
    rsync -am --include="*/" --include="*.gif" --include="*.ico" --include="*.jpg"  --include="*.pdf" --include="*.png" --include="*.mp4" --exclude="*" $SRCDIR/$TEMPLATES $WORKDIR/
    # html elements for rulesets
    rsync -am --include="*.css" --include="*.js" --include="*.htm" --include="*.html" --exclude="*" $SRCDIR/$TEMPLATES $WORKDIR/
    echo "plan directory [$PLANDIR] deployed under $WORKDIR/$TEMPLATES"
}
# a lib
function deploy_a_lib {
    lib="$1"
    
    if [  $# -gt 0 ]; then
	LIBDIR="$SRCDIR/$LIB/$lib"
	DESTDIR="$WORKDIR/$LIB/$lib"
    fi
    if ! [[ -d $LIBDIR ]]; then
	echo "ERROR: LIB directory [$LIBDIR] does not exists!"
	exit 1
    fi
    [[ -d $DESTDIR ]] || mkdir $DESTDIR
    rsync -am --include="*/" --include="*.pm" --exclude="*" $LIBDIR/ $DESTDIR/
    echo "lib directory [$LIBDIR] deployed under $DESTDIR/"
}

#
#
#
#

if [ $# -lt 1 ]; then
    echo "ERROR: deploy what?"
    usage
fi

key="$1"

case $key in
    -a|--all)
	deploy_all $2
	;;
    -p|--plans)
	deploy_plans $2
	;;
    -l|--lib)
	deploy_a_lib $2
	;;
    *)    # unknown option
	echo "ERROR: Unkown option => $key"
	usage
	;;
esac
