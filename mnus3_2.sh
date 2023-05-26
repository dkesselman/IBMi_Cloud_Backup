#/bin/bash

QIBM_MULTI_THREADED='Y'
export QIBM_MULTI_THREADED


source mnus3_const2.sh
source mnus3_inc2.sh

#***********************************************************************************#

  while [[ "$O" != " " ]]; do case $i in
        0) S=M0;SC;if [[ $cur == "" ]];then R;$e "\n$( BUCKETLS  )\n";ES;fi;;
        1) S=M1;SC;if [[ $cur == "" ]];then R;$e "\n$( BUCKETPT  )\n";ES;fi;;
        2) S=M2;SC;if [[ $cur == "" ]];then R;$e "\n$( BUCKETGT  )\n";ES;fi;;
        3) S=M3;SC;if [[ $cur == "" ]];then R;$e "\n$( BUCKETDL  )\n";ES;fi;;
        4) S=M4;SC;if [[ $cur == "" ]];then R;$e "\n$( BKPTOCLD  )\n";ES;fi;;
        5) S=M5;SC;if [[ $cur == "" ]];then R;$e "\n$( BKPTOCLD2 )\n";ES;fi;;  
        6) S=M6;SC;if [[ $cur == "" ]];then R;$e "\n$( LSTCLDBKP )\n";ES;fi;;  
        7) S=M7;SC;if [[ $cur == "" ]];then R;$e "\n$($e  ICOS Menu by ESSELWARE   )\n";ES;fi;;
        8) S=M8;SC;if [[ $cur == "" ]];then R;exit 0;fi;;
 esac;POS;done
