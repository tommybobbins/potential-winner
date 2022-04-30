# Answers in the case of break_wordpress being enabled

This is given in the terraform output and will increase the EC2 instance to 10GB:
```
aws ec2 modify-volume --size=10 --volume-id vol-05c4aaaaabvbss0dcca78 --region us-east-1
```

Login to the EC2 instance using the ssh string provided, sudo up and run

```
growpart /dev/nvme0n1 1
xfs_growfs /
```

The candidate should attempt to find the root cause and also clear/compress this file.
