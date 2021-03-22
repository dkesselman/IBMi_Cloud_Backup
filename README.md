# IBMi_Cloud_Backup

How many times have I herd "How can I backup my IBM i / AS/400 to the cloud?". 
Then I created a simple CL to backup all libraries to a remote NAS using SFTP/SCP/FTP, and works well till IBM Cloud appears.
Today we have IBM Cloud Power Virtual Servers (Power VS) where you can create your LPAR with IBM i/AIX/Linux on Power , and the solution "by the book" is to use IBM Cloud Object Storage (ICOS) + BRMS + ICC . ICOS is really inexpensive, BRMS is a great product, and ICC is easy to use, but...

* Most users DON'T use BRMS, and it's not so easy to setup, depending on your backup policies, so most people use SAVLIB/SAVDLO/SAV commands
* ICC needs specific IBM i versions and eats more resources you can expect. BTW: Why is ICC running all the time?
* BRMS and ICC have a price tag, SAVLIB/SAVDLO/SAV don't
* If you want to stream files to the cloud you need 

That's why I tried to create a simpler solution to use ICOS.

Most solutions on IBM i are Green-Screen , but as long as we need Python (in this case we use S3CMD ) to talk S3 lingo I just created a "simple" BASH script.

![Cloud Menu](https://github.com/dkesselman/IBMi_Cloud_Backup/blob/main/IBMi_Backup_to_Cloud.gif "IBM i Cloud Backup - Menu")

# Pre-Reqs

* You need to install YUM on your systems, I recommmend using Access Client Solution, and then install this tools:

Python3
readline
pigz
git

* Your system needs to reach the Internet. 
* Setup SSH on your System (5733-SC1)
* You need a bucket in IBM Cloud Object Storage. Try creating a free account https://www.ibm.com/mx-es/cloud/object-storage
* You need to download the tool s3cmd and configure properly   https://github.com/s3tools/s3cmd . I recommend to use "git clone https://github.com/s3tools/s3cmd.git "

You need to download the .sh to some directory on your IFS, something like "/IBMiCloudBackup/" , change permissions with chmod +x *.sh 

Now you just need to adjust values in mnus3_const.sh to reflect your configuration and now you can run *mnus3.sh* 


# UPDATE:

The files with "2" use "AWS CLI". On IBM i just type: pip3 install awscli and then you can run "aws configure" to create the files you need to connect to Cloud Object Storage. I think it's some kind faster.

On this update you can backup all your libraries with just one "INTRO" ;-)



