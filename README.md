# potential-winner
Terraform AWS EC2 instance, Apache webserver IPv6 subnet + mariadb installed locally + wordpress installed.

Based on a t3.nano which has 500MB of memory, this can lead to OOMs when performing a yum install. Added a temporary swapfile to work around this in the userdata.sh.

Has a nasty trick to fill up the disk space, this is as a training exercise to see if an engineer can detect this and what they do about it. This is set with the break_wordpress value in variables.tf

