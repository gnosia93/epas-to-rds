##
# AMI 정보를 어떻게 출력하는지 ?
# amzn2-ami-hvm-2.0.20210303.0-x86_64-gp2 (ami-0e17ad9abf7e5c818)
# 이미지가 update되는 경우 최신 버전의 AMI 를 받아오게 된다. 
data "aws_ami" "amazon-linux-2" {
    most_recent = true
    owners = [ "amazon" ]

    filter {
        name   = "owner-alias"
        values = ["amazon"]
    }

    filter {
        name   = "name"
        values = ["amzn2-ami-hvm*"]
    }
}


# How to list the latest available RHEL images on Amazon Web Services (AWS)
# https://access.redhat.com/solutions/15356
# RHEL-8.3.0_HVM-20201031-x86_64-0-Hourly2-GP2 (ami-07270d166cdf39adc)
data "aws_ami" "rhel-8" {
    most_recent = true
    owners = [ "309956199498" ]            # owner 309956199498 means redhat inc.

    #filter {
    #    name   = "owner-alias"
    #    values = ["309956199498"]
    #}

    filter {
        name   = "name"
        values = ["RHEL-8.3.0_HVM-20201031-x86*"]
    }
}


# ubuntu image for oracle 11g 
# ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201026 (ami-007b7745d0725de95)
data "aws_ami" "ubuntu-20" {
    most_recent = true
    owners = [ "099720109477" ]

    #filter {
    #    name   = "owner-alias"
    #    values = ["amazon"]
    #}

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201026*"]
    }
}



# ppas 13 setup
resource "aws_instance" "tf_ppas_13" {
    ami = data.aws_ami.ubuntu-20.id
    associate_public_ip_address = true
    instance_type = "c5.4xlarge"
    iam_instance_profile = aws_iam_instance_profile.tf_ec2_profile.name               # PVRE 설정을 막는다. PVRE 로 인해 오라클 인스턴스가 crash 가 일어나는듯~.
    monitoring = true
    root_block_device {
        volume_size = "300"
        volume_type = "io1"
        iops = "10000"
    }
    key_name = aws_key_pair.tf_key.id
    vpc_security_group_ids = [ aws_security_group.tf_sg_pub.id ]
    user_data = <<_DATA
#! /bin/bash

_DATA
    
    tags = {
      "Name" = "tf_ppas_13",
      "Project" = "ppas2rds"
    } 
}




#
# Output Section
#


output "tf_ppas_13_public_ip" {
    value = aws_instance.tf_ppas_13.public_ip
}



