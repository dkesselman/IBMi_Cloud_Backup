        E='echo -e';e='echo -en';trap "R;exit" 2                                
##    S3CMD='/QOpenSys/bin/s3cmd/s3cmd'   
      S3CMD='aws --endpoint-url=https://s3.us-south.cloud-object-storage.appdomain.cloud s3'                                   
BUCKETDFT='s3://ibmi-backup/'    
PREFIXDFT='IBMi01'                                          
  IFSPATH='/backup2cloud'      
   LIBLST=$IFSPATH'/liblist.lst'                                          
      ESC=$( $e "\e")
