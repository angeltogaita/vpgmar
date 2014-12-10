#!/bin/bash

## ================================================================
## Title:       myscript
## File:        myscript.sh
## ================================================================
## Description: Program that allow to processing for every kernel released
## 
## ================================================================
## Author:      Angelica Torres 
## ================================================================

# Input parameters
Path_file_location=$1;
Path_kernel=$2;
Path_file_type=$3;

WEBSITE_URL='https://www.kernel.org/pub/linux/kernel/v3.x/'

#lista1=$(grep PASS /nfs/etc/etc)
#for item in ${lista1[@]}
#do
#  usar $item
#done
#los scripts de bash no aceptan alias, como ll (en realidad es un ls -alF)

#[[ -d nfs/d ]] && haz_esto || sino_has_esto 

if [ "$Path_file_location" = "internet" ]; then 
  echo "Rutina para internet"
  wget –mirror $WEBSITE_URL 
else
  if [ "$Path_file_location" = "local" ]; then
   # Create and move to backup directory
   echo "Rutina local"
   current_d="$(pwd)" #="variable="$( <comand> )" This return the results of command in a string and save in to $variable
   llvar="$(ls -alF)"
   echo $current_d
   echo ${llvar[@]}
  else
    echo "INVALID ARGUMENT"
  fi    
fi 

[[ ! -d Temporal\ Directory ]] && mkdir Temporal\ Directory
cd Temporal\ Directory
mv linux-3.18.tar.xz Temporal\ Directory  
xz -d  linux-3.18.tar.xz # Descompress 
cd ./../
[[ ! -d Oficial\ Working\ Directory ]] && mkdir Oficial\ Working\ Directory
cd Oficial\ Working\ Directory
mv -rf ./../Temporal\ Directory/linux-3.18 ./

#---------------------pre-------------------------

[[ -f stats.pre ]] && rm stats.pre
touch stats.pre
echo "Files Names:" >> stats.pre
find linux-3.18/ -name "README.*" | wc -l | sed -e 's/\(.*\)/Number of READMEs: \1/g' >> stats.pre
find linux-3.18/ -name "Kconfig.*" | wc -l | sed -e 's/\(.*\)/Number of Kconfigs: \1/g' >> stats.pre
find linux-3.18/ -name "Kbuild.*" | wc -l | sed -e 's/\(.*\)/Number of Kbuild: \1/g' >> stats.pre
find linux-3.18/ -name "Makefiles.*" | wc -l | sed -e 's/\(.*\)/Number of Makefiles: \1/g' >> stats.pre
find linux-3.18/ -name ".c" | wc -l | sed -e 's/\(.*\)/Number of files .c: \1/g' >> stats.pre
find linux-3.18/ -name ".h" | wc -l | sed -e 's/\(.*\)/Number of files .h: \1/g' >> stats.pre
find linux-3.18/ -name ".pl" | wc -l | sed -e 's/\(.*\)/Number of files .pl: \1/g' >> stats.pre
ls | grep -vci "README.*\|Kconfig.*\|Kbuild.*\|Makefiles.*\|.c*\|.h*\|.pl*" | wc -l | sed -e 's/\(.*\)/Number of others: \1/g' >> stats.pre
ls | grep -ci ".*"  | wc -l | sed -e 's/\(.*\)/Number of totals: \1/g' >> stats.pre

echo "File Content:" >> stats.pre
grep -or "Linus" linux-3.18 |  wc -l | sed -e 's/\(.*\)/Number of occurrences of Linus: \1/g'>> stats.pre
grep -or "kernel_start" linux-3.18 |  wc -l | sed -e 's/\(.*\)/Number of occurrences of kernel_start: \1/g'>> stats.pre
grep -or "__init" linux-3.18 |  wc -l | sed -e 's/\(.*\)/Number of occurrences of __init: \1/g'>> stats.pre
grep -or " #include <linux/module.h>" linux-3.18 |  wc -l | sed -e 's/\(.*\)/Number of occurrences of  #include <linux/module.h>: \1/g'>> stats.pre
$ find linux-3.18/ -name "*" -print | xargs grep "gpio" | wc -l | sed -e 's/\(.*\)/Number of files in its filename containing the word gpio : \1/g' >> stats.pre

find arch/ -type d -name "*" | wc -l | sed -e 's/\(.*\)/Number of architectures/directories for arch: \1/g'>> stats.pre #para directorios
#------------------------------------------------

#---------------intel.contributors---------------
[[ ! -d intel.contributors ]] && mkdir intel.contributors
grep -E '\<[[A-Za-z0-9._%+-]+@intel\.com\>'| sed 's/^\(.*\):.*\([A-Za-z0-9._%+-]+@intel\.com/ \1 | \2 /g' >> intel.contributors
#------------------------------------------------

#---------------files----------------------------
[[ ! -d files_c ]] && mkdir files_c
[[ ! -d files_h ]] && mkdir files_h
[[ ! -d files_others ]] && mkdir files_others

mv -i Oficial\ Working\ Directory/"*.c" files_c
mv -i Oficial\ Working\ Directory/"*.h" files_h
#mv -i Oficial\ Working\ Directory/"*" files_others 

#------------------------------------------------
