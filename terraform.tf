
provider "aws" {
  region = var.region
}

provider "aws" {
  alias = "west"
  region = "ca-central-1"
}