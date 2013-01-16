#!/bin/bash

indent "0" "<interfaces>"
for interface in $(ifconfig -s |tail -n +2 |awk '{print $1}'); do
  indent_level=1
  indent "$indent_level" "<$interface>"
  ifconfig "$interface" | 
  ( 
    while read line; do
    indent_level=2
   if [[ "$line" =~ inet[[:space:]]addr:([[:graph:]]+)[[:space:]] ]]; then
      indent "$indent_level" "<address>${BASH_REMATCH[1]}</address>"
   fi
   if [[ "$line" =~ Bcast:([[:graph:]]+)[[:space:]] ]]; then
      indent "$indent_level" "<broadcast>${BASH_REMATCH[1]}</broadcast>"
   fi
   if [[ "$line" =~ Mask:([[:graph:]]+) ]]; then
      indent "$indent_level" "<netmask>${BASH_REMATCH[1]}</netmask>"
   fi
   if [[ "$line" =~ Link[[:space:]]encap:([[:graph:]]+) ]]; then
      indent "$indent_level" "<type>${BASH_REMATCH[1]}</type>"
   fi
   if [[ "$line" =~ HWaddr[[:space:]]([[:graph:]]+) ]]; then
      indent "$indent_level" "<MAC>${BASH_REMATCH[1]}</MAC>"
   fi
    done
  )
  indent_level_=1
  indent "$indent_level" "</$interface>"

done

echo "</interfaces>"
