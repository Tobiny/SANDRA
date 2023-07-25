#!/usr/bin/env bash

ROOTPATH=$( cd `dirname "$0"`; pwd -P )
export SSMPATH="$ROOTPATH/configuration/pegasus/"

JAVAPATH=""

if [ -f "javapath.txt" ]
then
    while IFS= read line
    do
        if ! [[ $line =~ ^\#.* ]] ;
        then
            JAVAPATH="${line//[$'\r\n']}"
        fi
    done <"javapath.txt"
fi

if [ -z $JAVAPATH ]
then
    JAVAPATH="java"
fi

VMARGS=""

for fileName in start.args vm-args.txt RESOURCE/DEFAULT.INI RESOURCE/CDVIEWER.INI
do
    if [ -f $fileName ]
    then
        while IFS= read line
        do
            if ! [[ $line =~ ^\#.* ]] ;
            then
                VMARGS+=" ${line//[$'\r\n']}"
            fi
        done <$fileName
    fi
done

if ! [[ $VMARGS =~ "-Xms" ]] ;
then
    VMARGS+=" -Xms1000m"
fi

if ! [[ $VMARGS =~ "-Xmx" ]] ;
then
    VMARGS+=" -Xmx1000m"
fi

while :
do
    $JAVAPATH $VMARGS -jar plugins/org.eclipse.equinox.launcher-1.5.200.jar -application com.agfa.pacs.login.LoginManager
    [[ $? == 23 ]] || break
done
