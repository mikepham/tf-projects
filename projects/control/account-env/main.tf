provider "aws" {
  profile = "nativecode-${var.environment}"
  region  = var.region
  version = ">=2.25"
}
