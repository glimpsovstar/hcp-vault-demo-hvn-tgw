resource "hcp_hvn" "djoo_hcp_vault_demo_hvn" {
  hvn_id         = "djoo-hcp-vault-demo-hvn"
  cloud_provider = "aws"
  region         = var.region
  cidr_block     = var.hvn_cidr
}

resource "aws_ec2_transit_gateway" "twg-djoo_hcp_vault_demo" {
}

resource "aws_ram_resource_share" "djoo_hcp_vault_demo_resource_share" {
  name                      = "djoo_hcp_vault_demo_resource_share"
  allow_external_principals = true
}

resource "aws_ram_principal_association" "djoo_hcp_vault_demo_principal_association" {
  resource_share_arn = aws_ram_resource_share.djoo_hcp_vault_demo_resource_share.arn
  principal          = hcp_hvn.djoo_hcp_vault_demo_hvn.provider_account_id
}

resource "aws_ram_resource_association" "djoo_hcp_vault_demo_resource_association" {
  resource_share_arn = aws_ram_resource_share.djoo_hcp_vault_demo_resource_share.arn
  resource_arn       = aws_ec2_transit_gateway.twg-djoo_hcp_vault_demo.arn
}

resource "hcp_aws_transit_gateway_attachment" "djoo_hcp_vault_demo_tgw_attachment" {
  depends_on = [
    aws_ram_principal_association.djoo_hcp_vault_demo_principal_association,
    aws_ram_resource_association.djoo_hcp_vault_demo_resource_association,
  ]

  hvn_id                        = hcp_hvn.djoo_hcp_vault_demo_hvn.hvn_id
  transit_gateway_attachment_id = "djoo_hcp_vault_demo_hvn-tgw-attachment"
  transit_gateway_id            = aws_ec2_transit_gateway.twg-djoo_hcp_vault_demo.id
  resource_share_arn            = aws_ram_resource_share.djoo_hcp_vault_demo_resource_association.arn
}

resource "hcp_hvn_route" "djoo_hcp_vault_demo_route" {
  hvn_link         = hcp_hvn.djoo_hcp_vault_demo_hvn.self_link
  hvn_route_id     = "djoo_hcp_vault_demo_hvn-hvn-to-tgw-attachment"
  destination_cidr = aws_vpc.example.cidr_block
  target_link      = hcp_aws_transit_gateway_attachment.djoo_hcp_vault_demo_tgw_attachment.self_link
}