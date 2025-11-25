provider "aws" {    
    region = "us-east-2"
}

module "iam_users" {
    source = "../../../modules/landing-zone"

    count     = length(var.user_names)
    user_name = var.user_names[count.index]
}