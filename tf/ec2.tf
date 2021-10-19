
// resource "aws_iam_role" "tf_ec2_service_role" {

resource "aws_instance" "tf_loadgen" {
    ami = data.aws_ami.amazon-linux-2.id
    associate_public_ip_address = true
    instance_type = "t2.xlarge"
    iam_instance_profile = aws_iam_instance_profile.tf_ec2_profile.name
    monitoring = true
    root_block_device {
        volume_size = "30"
    }
    key_name = aws_key_pair.tf_key.id
    vpc_security_group_ids = [ aws_security_group.tf_sg_pub.id ]
    user_data = <<_DATA
#! /bin/bash
sudo yum install -y python37 git telnet
sudo pip3 install cx_oracle
sudo -u ec2-user git clone https://github.com/gnosia93/oracle-to-postgres-pyoracle.git /home/ec2-user/pyoracle
sudo -u ec2-user mkdir -p /home/ec2-user/pyoracle/images
sudo -u ec2-user curl -o /home/ec2-user/pyoracle/images/images.tar http://www.studydev.com/images.tar
sudo -u ec2-user tar xvf /home/ec2-user/pyoracle/images/images.tar -C /home/ec2-user/pyoracle/images

_DATA

    tags = {
      "Name" = "tf_loadgen",
      "Project" = "ppas2rds"
    } 
}


output "load_gen_public_ip" {
    value = aws_instance.tf_loadgen.public_ip
}
