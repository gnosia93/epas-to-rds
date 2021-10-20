variable "your_ip_addr" {
    type = string
    default = "218.238.107.0/24"       ## 네이버에서 "내아이피" 로 검색한 후, 결과값을 CIDR 형태로 입력.
}

variable "edb_username" {
    type = string
    default = "soonbeom"       
}

variable "edb_password" {
    type = string
    default = "SEPkKn6vTkQncKDn"       
}