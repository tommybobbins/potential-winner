# potential-winner
Terraform AWS EC2 instance, Apache webserver IPv6 subnet + mariadb installed locally + wordpress installed.

For Demo and for being the cheapest way of spinning up Wordpress purposes only. Don't use this for production:
* Not highly available
* Doesn't use RDS
* Is in a single AZ
* Doesn't use static content
* Has no caching
* Doesn't use EFS
* Doesn't use CloudFront. 
Use this if you must use Wordpress: https://d1.awsstatic.com/whitepapers/wordpress-best-practices-on-aws.pdf

Based on a t3.nano which has 500MB of memory, this can lead to OOMs when performing a yum install. Added a temporary swapfile to work around this in the userdata.sh.

## Interview Mode
This has as a training exercise mode to see if an engineer can detect why Wordpress is broken and what they do about it in a paired programming exercise. This is set with the break_wordpress value in variables.tf
