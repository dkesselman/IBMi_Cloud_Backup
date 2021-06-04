        E='echo -e';e='echo -en';trap "R;exit" 2             
    S3CMD='aws --endpoint-url=https://s3.us-south.cloud-object-storage.appdomain.cloud s3 '
  IFSPATH='/backup2cloud'      
   LIBLST=$IFSPATH'/liblist.lst'     
  FLISTHD='System-- Save Date/Time Object--- Type---- Attribute- Size (Bytes)---- Owner------ Description--------------' 
      ESC=$( $e "\e")
num_procs=3
   pgzthr=12
  maxsize=20
