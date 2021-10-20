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
# Setup the EDB repository

sudo su -c 'echo "deb [arch=amd64] https://apt.enterprisedb.com/$(lsb_release -cs)-edb/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/edb-$(lsb_release -cs).list'

# Replace '<USERNAME>' and '<PASSWORD>' below with your username and password for the EDB repositories. Visit https://www.enterprisedb.com/user to get your username and password
sudo su -c 'echo "machine apt.enterprisedb.com login ${var.edb_username} password ${var.edb_password}" > /etc/apt/auth.conf.d/edb.conf'

# Add support for secure APT repositories
sudo apt-get -y install apt-transport-https

# Add the EDB signing key
sudo wget -q -O - https://apt.enterprisedb.com/edb-deb.gpg.key  | sudo apt-key add -

# Update the repository meta data
sudo apt-get update

# Install selected packages
sudo apt-get -y install edb-as13-server 
_DATA
    
    tags = {
      "Name" = "tf_ppas_13",
      "Project" = "ppas2rds"
    } 
}


# rds setup
resource "aws_db_subnet_group" "tf_db_subnet_grp" {
  name       = "tf-db-subnet-grp"
  subnet_ids = data.aws_subnet_ids.tf_subnet_ids.ids

  tags = {
    Name = "tf-db-subnet-grp"
  }
}

resource "aws_db_parameter_group" "tf-db-parameter-grp" {
  name   = "pg-postgres-rds"
  family = "postgres13"

/*
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
*/
}



resource "aws_db_instance" "tf_postgres_rds" {
  identifier             = "tf-postgres-rds"
  instance_class         = "db.m6g.4xlarge"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.4"
  username               = "postgres"
  password               = "postgres"
  db_subnet_group_name   = aws_db_subnet_group.tf_db_subnet_grp.name
  vpc_security_group_ids = [aws_security_group.tf_sg_pub.id]
  parameter_group_name   = aws_db_parameter_group.tf-db-parameter-grp.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}












#
# Output Section
#
output "tf_ppas_13_public_dns" {
    value = aws_instance.tf_ppas_13.public_dns
}

output "tf_postgres_rds_endpoint" {
    value = aws_db_instance.tf_postgres_rds.endpoint
}



