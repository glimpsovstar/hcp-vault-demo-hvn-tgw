provider "hcp" {
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Name = var.Name
      Owner = var.owner
      TTL = var.TTL
      Environment = "dev"
    }
  } 
}