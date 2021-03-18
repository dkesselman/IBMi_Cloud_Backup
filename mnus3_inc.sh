    TPUT(){ $e "\e[${1};${2}H";}                                                                                                                                             
   CLEAR(){ $e "\ec";}                                                                                                                                                       
   CIVIS(){ $e "\e[?25l";}                                                                                                                                                    
    DRAW(){ $e "\e%@\e(0";}                                                                                                                                                  
   WRITE(){ $e "\e(B";}                                                                                                                                                      
    MARK(){ $e "\e[7m";}                                                                                                                                                     
  UNMARK(){ $e "\e[27m";}                                                                                                                                                     
    LINE(){ $E ""; $E "\033(0rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr\033(B";}                                                                      
                                                                                                                                                                             
#***********************************************************************************#                                                                
#                           Cloud Functions                                         #                                                                                        
#***********************************************************************************#                                                                                        
                                                                                                                                                                             
BUCKETLS(){ read -p "Bucket name [$BUCKETDFT]: " bucket;bucket=${bucket:-$BUCKETDFT}; $S3CMD ls $bucket;LINE;}                                                                    
BUCKETPT(){ read -p "Bucket name+PREFIX : " bucket; read -p "File on IFS:" ifsfile; $S3CMD put $ifsfile $bucket;LINE;}                                                        
BUCKETGT(){ read -p "Bucket name+PREFIX+File Name : " icosobject; read -p "File destination on IFS:" ifsfile; $S3CMD get $icosobject $ifsfile ;LINE;}                        
BUCKETDL(){ read -p "Bucket name+PREFIX+File Name : " icosobject; $S3CMD -v rm $icosobject ;LINE;}                                                                           
 ASKLIB1(){ read -p "Library name: " libname; read -p "Bucket name+PREFIX: " bucket; ifsfile=$IFSPATH$libname.zip ;}                                                          
 CRTLIB1(){ mkdir -p $IFSPATH; system "CRTLIB BACKUPSAV" ;}                                                                                                                   
 SAVLIB1(){ $E "Saving Library";LINE;system "DLTF BACKUPSAV/$libname";system "CRTSAVF BACKUPSAV/$libname"; system "SAVLIB LIB($libname) DEV(*SAVF) SAVF(BACKUPSAV/$libname) SAVACT(*LIB) SAVACTWAIT(60) "; }                       
 ZIPLIB1(){ $e "Compression...";LINE;cd /QSYS.LIB/BACKUPSAV.LIB/;rm /$IFSPATH/$libname.zip ;pigz -v -K -c $libname.FILE > /$IFSPATH/$libname.zip ; }                       
     B2C(){ $e "S3CMD put $ifsfile $bucket"; $S3CMD put $ifsfile $bucket ;}                                                                                                  
BKPTOCLD(){ ASKLIB1;CRTLIB1;SAVLIB1;ZIPLIB1; B2C ;LINE;}                                                                                                                         
#***********************************************************************************#                                                            
                                                                                                                            
      R(){ CLEAR ;stty sane;$e "\ec\e[37;44m\e[J";};                                                                                                                          
    HEAD(){ DRAW                                                                                                                                                        
           TPUT 4 0                                                                                                                                                       
           for each in $(seq 1 13);do                                                                                                                                     
           $E "   x                                          x"                                                                                                             
           done                                                                                                                                                             
           WRITE;MARK;TPUT 4 5                                                                                                                                               
           $E "IBM CLOUD BACKUP MENU                     ";UNMARK;}                                                                                                           
           i=0; CLEAR; CIVIS;NULL=/dev/null                                                                                                                                   
   FOOT(){ MARK;TPUT 16 5                                                                                                                                                  
           printf "ENTER - SELECT,NEXT                       ";UNMARK;}                                                                                                      
  ARROW(){ read -s -n3 key 2>/dev/null >&2                                                                                                                                  
           if [[ $key = $ESC[A ]];then echo up;fi                                                                 
           if [[ $key = $ESC[B ]];then echo dn;fi;}                                                                                                                        
     M0(){ TPUT  7 11; $e "List Bucket content on IBM COS";}                                                                                                            
     M1(){ TPUT  8 11; $e "Upload file to IBM COS        ";}                                                                                                                  
     M2(){ TPUT  9 11; $e "Get file from IBM COS         ";}                                                                                                                 
     M3(){ TPUT 10 11; $e "Delete file from IBM COS      ";}                                                                                                                
     M4(){ TPUT 11 11; $e "Save Library to IBM COS       ";}                                                                                                              
     M5(){ TPUT 12 11; $e "ABOUT                         ";}                                                                                                                  
     M6(){ TPUT 13 11; $e "EXIT                          ";}                                                                                                          
      LM=6                                                                                                                                                                        
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}                                                                                                                      
   POS(){ if [[ $cur == up ]];then ((i--));fi                                                                                                                                
           if [[ $cur == dn ]];then ((i++));fi                                                                                                                                
           if [[ $i -lt 0   ]];then i=$LM;fi                                                                                                                                 
           if [[ $i -gt $LM ]];then i=0;fi;}                                                                                                                                
REFRESH(){ after=$((i+1)); before=$((i-1))                                                                                                                                   
           if [[ $before -lt 0  ]];then before=$LM;fi                                                                                                                      
           if [[ $after -gt $LM ]];then after=0;fi                                                                                                                           
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi                                                                                               
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then                                                                                                                  
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}                                                                                                        
   INIT(){ R;HEAD;FOOT;MENU;}                                                                                                                                            
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}                                                                                                                                 
     ES(){ MARK;$e "    ENTER = main menu    ";$b;read;INIT;};INIT                                       
                                  
