output "hvn-id" {
  value = hcp_hvn.djoo_hcp_vault_demo_hvn.hvn_id
}

output "hvn-self-link" {
  value = hcp_hvn.djoo_hcp_vault_demo_hvn.self_link
}

output "hvn-cidr-block" {
  value = hcp_hvn.djoo_hcp_vault_demo_hvn.cidr_block
}

output "vpc-id" {
  value = aws_vpc.djoo_hcp_vault_demo_vpc.id
}

output "vpc-subnet-id" {
  value = aws_subnet.djoo_hcp_vault_demo_subnet.id
}

output "security-group-id" {
  value = aws_security_group.ssh-http-https-allowed.id
}
