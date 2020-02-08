provider "aws" {
  region  = var.region
  profile = "nativecode-${var.environment}"
  version = ">=2.25"
}
