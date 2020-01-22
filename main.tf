terraform {
  backend "s3" {
    bucket  = "nativecode"
    encrypt = true
    key     = "nativecode.tfstate"
    profile = "nativecode"
    region  = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
