    TPUT(){ $e "\e[${1};${2}H";}                                             
   CLEAR(){ $e "\ec";}                                                                                                         
   CIVIS(){ $e "\e[?25l";}                                                                                                     
    DRAW(){ $e "\e%@\e(0";}                                                                                                    
   WRITE(){ $e "\e(B";}                                                                                                        
    MARK(){ $e "\e[7m";}                                                                                                       
  UNMARK(){ $e "\e[27m";}
                                                                                                                        
    LINE(){ $E ""; $E "\033(0rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr\033(B";}  
   LINE2(){ $E ""; $E "==================================================================="; }  
     POS(){ if [[ $cur == up ]];then ((i--));fi
            if [[ $cur == dn ]];then ((i++));fi
            if [[ $i -lt 0   ]];then i=$LM;fi
            if [[ $i -gt $LM ]];then i=0;fi; } 
                    
                                                                                                                           
#***********************************************************************************#                                      
#                           Cloud Functions                                         #                                      
#***********************************************************************************#                                      
                                                                                                                          
BUCKETLS(){ read -p "Bucket to list: " s3path ; $S3CMD ls $s3path;LINE;}                                       
BUCKETPT(){ read -p "ICOS Bucket : " s3path ; read -p "File on IFS:" ifsfile; $S3CMD cp $ifsfile $s3path ;LINE;}                          
BUCKETGT(){ read -p "ICOS Source file : " s3object; read -p "Target directory on IFS:" ifsfile; $S3CMD cp $s3object $ifsfile ;LINE;}
BUCKETDL(){ read -p "ICOS Source file : " s3object; $S3CMD  rm $s3object 2>&1 ;LINE;}                                     
 ASKLIB1(){ read -p "Library name: " libname; read -p "ICOS Bucket: " s3path; ifsfile=$IFSPATH/$libname.7z ;} 
 SAVLIST(){ listfile=$IFSPATH'/'$libname'_lst';system "CPYTOIMPF FROMFILE(BACKUPSAV/BKPLOG $libname ) TOSTMF('$listfile') MBROPT(*ADD) STMFCCSID(1208) RCDDLM(*CRLF) DTAFMT(*DLM) DATFMT(*YYMD)" ;} 
 CRTLIB1(){ mkdir -p $IFSPATH  2>&1; system "CRTLIB BACKUPSAV" 2>&1 ;  }         
     B2C(){ $S3CMD cp $ifsfile $s3path ;$S3CMD cp $ifslog $s3path;}                                                                                                                                                       
BKPTOCLD(){ ASKLIB1;CRTLIB1;SAVLIB1;SAVLIST;ZIPLIB1; B2C;LINE2;}            
SAVZIP2(){ $E 'Saving Library:' $libname ' - ' $dt;SAVLIB1;SAVLIST;ZIPLIB1;B2C;LINE2;}
 UNZIP1(){ 7z e -y $libname"_lst.7z" ; }
#***********************************************************************************#        
LSTCLDBKP(){
ASKLIB1;
cd $IFSPATH
s3object=$s3path"/"$libname"_lst.7z";
echo $s3object  ;
$S3CMD cp $s3object $IFSPATH ; 
UNZIP1;
#------------------------------------------
CLEAR;WRITE;MARK;TPUT 6 0 
$E $FLISTHD; 
awk -F "," '{print($3,$12,$13,$15,$16,$17,$18,$22)}' $libname"_lst" | tr -d '"';
#------------------------------------------
}
#***********************************************************************************#                                                                                                                                                     
 SAVLIB1(){ 

rm $IFSPATH"/"$libname".7z*" 2>&1
rm $IFSPATH"/"$libname"_lst.7z*" 2>&1

if [ -f "/QSYS.LIB/BACKUPSAV.LIB/"$libname".FILE" ]; then
    rm /QSYS.LIB/BACKUPSAV.LIB/$libname.FILE  2>&1 ;
fi
system "RMVM FILE(BACKUPSAV/BKPLOG) MBR($libname)" 2>&1;
system "CRTSAVF BACKUPSAV/$libname"; 
system "SAVLIB LIB($libname) DEV(*SAVF) SAVF(BACKUPSAV/$libname) SAVACT(*LIB) SAVACTWAIT(60) OUTPUT(*OUTFILE) OUTFILE(BACKUPSAV/BKPLOG) OUTMBR($libname)"; 
}
#***********************************************************************************#        
 ZIPLIB1(){ 
cd /QSYS.LIB/BACKUPSAV.LIB/;
if [ -f $IFSPATH"/"$libname".7z*" ]; then
    rm $IFSPATH"/"$libname".7z*" 2>&1 ; 
fi

$e "Compressing: " $libname ;

cd $IFSPATH;

cat "/QSYS.LIB/BACKUPSAV.LIB/"$libname".FILE" |7z a -mx1 -mmt${pgzthr} -si $libname".7z";

rm "/QSYS.LIB/BACKUPSAV.LIB/"$libname".FILE" 2>&1 ;
ifslog=$IFSPATH"/"$libname"_lst.7z";
cd $IFSPATH; 
cat $IFSPATH"/"$libname"_lst"| 7z a -mx1 -si $ifslog;
rm $libname"_lst" 2>&1 ;
}  
#***********************************************************************************#        
SAVSECDTA(){ 
if [ -f /QSYS.LIB/BACKUPSAV.LIB/SAVSECDTA.FILE ]; then
    rm /QSYS.LIB/BACKUPSAV.LIB/SAVSECDTA.FILE 2>&1 ;
fi
system "CRTSAVF BACKUPSAV/SAVSECDTA"; 
system "SAVSECDTA DEV(*SAVF) SAVF(BACKUPSAV/SAVSECDTA) OUTPUT(*OUTFILE) OUTFILE(BACKUPSAV/BKPLOG) OUTMBR(SAVSECDTA)"; 
libname="SAVSECDTA";
ifsfile=$IFSPATH"/"$libname".7z";
SAVLIST;
ZIPLIB1;
B2C; 
}   
#***********************************************************************************#                                                                                                                                                     
BKPTOCLD2(){
CRTLIB1; 
#Purge BACKUPSAV library and IFS path
rm /QSYS.LIB/BACKUPSAV.LIB/*.FILE 2>&1
rm $IFSPATH/*.7z* 2>&1
rm $IFSPATH/*_lst 2>&1

#List libraries excluding Q*, SYS* & ASN
cd /QSYS.LIB;
ls |grep '\.LIB' |grep -Fv -e 'Q' -e 'SYS' -e '#' -e 'ASN' -e 'BACKUPSAV'  > $LIBLST;

#Add some libraries to the list
$E "QGPL.LIB"    >> $LIBLST;    
$E "QS36F.LIB"   >> $LIBLST;    
$E "QUSRSYS.LIB" >> $LIBLST;    

dt=$(date '+%Y%m%d-%H%M%S');
dt2=$(date '+%Y%m%d');
LOGNAME=$IFSPATH'/BAK'$dt'.log';                                                                                                                                                      
s3path=$BUCKET'/BKP'$dt2'/';

$E 'SAVING DATA TO :' $s3path

$E 'Starting Backup: BKP' $dt2 ' - ' $dt > $LOGNAME    

# Save Security Data

$E 'Saving Security Data: ' $s3path  >> $LOGNAME    
 
SAVSECDTA;                 

# Save library 1 by 1
i=0;
num_jobs="\j"
liblst=$(cat $LIBLST);
for libname2 in $liblst
do
		libname=${libname2:0:${#libname2}-4}
        i=$((i+1));
        ifsfile=$IFSPATH"/"$libname".7z" ;
        dt=$(date '+%Y%m%d-%H%M%S');
		SAVZIP2 >> $LOGNAME & 
        while (( ${num_jobs@P} >= num_procs )) 
        do
            wait -n
        done
done

wait

LINE2;
$e $i "Libraries backed up to " $s3path;
 
dt=$(date '+%Y%m%d-%H%M%S');
echo 'Backup ending: BKP' $dt2 ' - ' $dt >> $LOGNAME                                                                                                                                                                                     
} 
#***********************************************************************************#                             
                                                                                                    
      R(){ CLEAR ;stty sane;$e "\ec\e[96m\e[J";};                                          
    HEAD(){ DRAW                                                                      
           TPUT 4 0                                                         
           for each in $(seq 1 14);do                                                                                          
           $E "   x                                          x"                                                                
           done                                                                                                                
           WRITE;MARK;TPUT 4 5                                                                                                  
           $E "       ICOS CLOUD BACKUP MENU             ";UNMARK;}                                                            
           i=0; CLEAR; CIVIS;NULL=/dev/null                                                                                
   FOOT(){ MARK;TPUT 17 5                                                                                                 
           printf "ENTER - SELECT,NEXT                       ";UNMARK;}     
                                               
  ARROW(){ read -s -n3 key 2>/dev/null >&2                                                                                
        if [[ $key = $ESC[A ]];then echo up;fi                                                           
        if [[ $key = $ESC[B ]];then echo dn;fi; }   
                                                                          
     M0(){ TPUT  7 11; $e "List content on ICOS          ";}                                                               
     M1(){ TPUT  8 11; $e "Upload file to ICOS           ";}                                                               
     M2(){ TPUT  9 11; $e "Get file from ICOS            ";}                                                              
     M3(){ TPUT 10 11; $e "Delete file from ICOS         ";}                                                              
     M4(){ TPUT 11 11; $e "Save Library to ICOS          ";}                                                                    
     M5(){ TPUT 12 11; $e "Save ALL Libraries to ICOS    ";}                                                               
     M6(){ TPUT 13 11; $e "List library saved on ICOS    ";}
     M7(){ TPUT 14 11; $e "ABOUT                         ";}                                                              
     M8(){ TPUT 15 11; $e "EXIT                          ";}                                                             
      LM=8;                                    
                                                                             
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}                                                                     

REFRESH(){ after=$((i+1)); before=$((i-1))                                                                                 
           if [[ $before -lt 0  ]];then before=$LM;fi                                                                     
           if [[ $after -gt $LM ]];then after=0;fi                                                                        
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi                                                  
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then                                                                    
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}                           
   INIT(){ R;HEAD;FOOT;MENU;}                                                                                              
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}                                                                                   
     ES(){ MARK;$e "    ENTER = Main Menu    ";$b;read;INIT;};INIT          
