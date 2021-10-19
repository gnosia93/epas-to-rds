resource "null_resource" "previous" {}

# dms_vpc_role 이 먼저 생성될 수 있도록 기다린다. 
# AWS 콘솔화면에서는 dms_vpc_role 이 자동으로 생성되지만, CLI, API 에서는 생성해줘야 한다. 
# 해당 role은 security.tf 에서 생성함.
resource "time_sleep" "wait_10_seconds" {
  depends_on = [null_resource.previous]
  create_duration = "60s"
}


# 
# DMS를 위한 서브넷의 경우 설정하지 않더라도 default 라는 이름의 서브넷 그룹을 자동으로 생성해 준다. 
#

resource "aws_dms_replication_instance" "tf_dms_ppas" {
    allocated_storage = 50
    apply_immediately = true
    engine_version = "3.4.3"
    multi_az = false
    publicly_accessible = true
    replication_instance_class = "dms.c5.xlarge"
    replication_instance_id = "tf-dms-ppas"

    depends_on = [time_sleep.wait_10_seconds]
}



resource "aws_dms_endpoint" "tf_dms_ep_ppas" {
    endpoint_id = "tf-dms-ep-ppas"
    endpoint_type = "source"
    engine_name = "postgres"
    server_name = aws_instance.tf_ppas_13.public_dns
    database_name = "shop_db"                                      ## database name
    username = "shop"
    password = "shop"
    port = 5444
    extra_connection_attributes = ""
    ssl_mode = "none"
}

resource "aws_dms_endpoint" "tf_dms_ep_rds" {
    endpoint_id = "tf-dms-ep-rds"
    endpoint_type = "target"
    engine_name = "postgres"
    server_name = aws_instance.tf_ppas_13.public_dns          ## rds (required)
    database_name = "shop_db"                                      ## database name
    username = "shop"
    password = "shop"
    port = 5432
    extra_connection_attributes = ""
    ssl_mode = "none"
}

#
# Output Section
#
