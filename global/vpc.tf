resource "aws_vpc" "main" {
  cidr_block       = "${var.cidr_block}"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "genesis"
  }
}

resource "aws_subnet" "main-public-1" {
   vpc_id = "${aws_vpc.main.id}"
   cidr_block = "${var.public_subnet_1}"
   map_public_ip_on_launch = "true"
   availability_zone = "us-east-1a"
   tags = {
       Name = "main-public-subnet-1a"
    }
}

resource "aws_subnet" "main-public-2" {
   vpc_id = "${aws_vpc.main.id}"
   cidr_block = "10.0.2.0/24"
   map_public_ip_on_launch = "true"
   availability_zone = "us-east-1b"
   tags = {
       Name = "main-public-subnet-1b"
    }
}

resource "aws_subnet" "main-private-1" {
   vpc_id = "${aws_vpc.main.id}"
   cidr_block = "10.0.3.0/24"
   map_public_ip_on_launch = "false"
   availability_zone = "us-east-1a"
   tags = {
       Name = "main-private-subnet-1a"
    }
}

resource "aws_subnet" "main-private-2" {
   vpc_id = "${aws_vpc.main.id}"
   cidr_block = "10.0.4.0/24"
   map_public_ip_on_launch = "false"
   availability_zone = "us-east-1b"
   tags = {
       Name = "main-private-subnet-1b"
    }
}

resource "aws_internet_gateway" "main-gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags = {
        Name = "main-gw"
    }
}

resource "aws_route_table" "main-public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main-gw.id}"
    }

    tags = {
        Name = "main-public-1"
    }
}

resource "aws_route_table_association" "main-public-1" {
    subnet_id = "${aws_subnet.main-public-1.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}
resource "aws_route_table_association" "main-public-2" {
    subnet_id = "${aws_subnet.main-public-2.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}

resource "aws_eip" "main-nat" {
vpc      = true
}

resource "aws_nat_gateway" "main-nat-gw" {
allocation_id = "${aws_eip.main-nat.id}"
subnet_id = "${aws_subnet.main-public-1.id}"
depends_on = ["aws_internet_gateway.main-gw"]
}

resource "aws_route_table" "main-private" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.main-nat-gw.id}"
    }

    tags = {
        Name = "main-private-1"
    }
}

resource "aws_route_table_association" "main-private-1" {
    subnet_id = "${aws_subnet.main-private-1.id}"
    route_table_id = "${aws_route_table.main-private.id}"
}

resource "aws_route_table_association" "main-private-2" {
    subnet_id = "${aws_subnet.main-private-2.id}"
    route_table_id = "${aws_route_table.main-private.id}"
}

resource "aws_route53_zone" "TreppPrivate" {
   name = "trepp.com"
   vpc {
      vpc_id = "${aws_vpc.main.id}"
   }
}

resource "aws_vpc_dhcp_options" "maindhcp" {
   domain_name = "trepp.com"
   domain_name_servers = ["AmazonProvidedDNS"]
}

