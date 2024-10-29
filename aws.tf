resource "aws_vpc" "djoo_hcp_vault_demo_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "djoo HCP Vault Demo VPC"
  }
}

resource "aws_subnet" "djoo_hcp_vault_demo_subnet" {
  vpc_id            = aws_vpc.djoo_hcp_vault_demo_vpc.id
  cidr_block = var.vpc_cidr
  availability_zone = var.az
  tags = {
    Name = "djoo HCP Vault Demo Subnet"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "djoo_hcp_vault_demo_ec2_tgw_attachment" {
  subnet_ids         = [aws_subnet.djoo_hcp_vault_demo_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.twg-djoo_hcp_vault_demo.id
  vpc_id             = aws_vpc.djoo_hcp_vault_demo_vpc.id
  depends_on = [ 
    aws_ec2_transit_gateway.twg-djoo_hcp_vault_demo, 
  ]
}

resource "aws_internet_gateway" "djoo_hcp_vault_demo_vpc-igw" {
  vpc_id = "${aws_vpc.djoo_hcp_vault_demo_vpc.id}"
  tags = {
    Name = "djoo HCP Vault Demo VPC IGW"
  }
}

resource "aws_main_route_table_association" "djoo_hcp_vault_demo_main-rt-assoc" {
  vpc_id         = "${aws_vpc.djoo_hcp_vault_demo_vpc.id}"
  route_table_id = "${aws_route_table.djoo_hcp_vault_demo-main-rt.id}"
}

resource "aws_route_table" "djoo_hcp_vault_demo-main-rt" {
  vpc_id = "${aws_vpc.djoo_hcp_vault_demo_vpc.id}"

  route {
    cidr_block = var.hvn_cidr
    transit_gateway_id = "${aws_ec2_transit_gateway.twg-djoo_hcp_vault_demo.id}"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.djoo_hcp_vault_demo_vpc-igw.id}"
  }

  depends_on = [ 
      aws_ec2_transit_gateway.twg-djoo_hcp_vault_demo,
      aws_ec2_transit_gateway_vpc_attachment.djoo_hcp_vault_demo_ec2_tgw_attachment,
  ]
  tags = {
    Name = "djoo HCP Vault Demo Main Route Table"
  }
}