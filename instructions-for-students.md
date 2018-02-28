## MAC

- Got to github: https://github.com/snewhouse/genmed-msc-2018.git
- download folder



Move in the folder you just downloaded.

```bash
cd genmed-msc-2018
```

change file permissions of the security key

```bash
chmod 400 teaching-gen-med-msc.pem
```

use ssh to connect to AWS


```bash
USERNAME="ngsuser_1" ## <---------------- enter your random user id
ssh -i ./teaching-gen-med-msc.pem ${USERNAME}@ec2-34-240-250-169.eu-west-1.compute.amazonaws.com
```

## WINDOWS

- Go to: https://www.katacoda.com/courses/ubuntu/playground
- start scenario

```bash
git clone https://github.com/snewhouse/genmed-msc-2018.git
cd genmed-msc-2018
chmod 400 teaching-gen-med-msc.pem
## connect
USERNAME="ngsuser_2" ## <---------------- enter your random user id
ssh -i ./teaching-gen-med-msc.pem ${USERNAME}@ec2-34-240-250-169.eu-west-1.compute.amazonaws.com
```


***********************


## AWS Image Url

- ec2-34-240-250-169.eu-west-1.compute.amazonaws.com

## User names

ngsuser_1 - ngsuser_40 e.g.:-

```bash
ssh -i ./teaching-gen-med-msc.pem ngsuser_1@ec2-34-240-250-169.eu-west-1.compute.amazonaws.com
ssh -i ./teaching-gen-med-msc.pem ngsuser_2@ec2-34-240-250-169.eu-west-1.compute.amazonaws.com
ssh -i ./teaching-gen-med-msc.pem ngsuser_3@ec2-34-240-250-169.eu-west-1.compute.amazonaws.com
ssh -i ./teaching-gen-med-msc.pem ngsuser_4@ec2-34-240-250-169.eu-west-1.compute.amazonaws.com
ssh -i ./teaching-gen-med-msc.pem ngsuser_5@ec2-34-240-250-169.eu-west-1.compute.amazonaws.com
```