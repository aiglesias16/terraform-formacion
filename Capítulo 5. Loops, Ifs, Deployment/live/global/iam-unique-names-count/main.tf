provider "aws" {
    region = "us-east-2"
}

resource "aws_iam_user" "example" {
    ## Allows us to create multiple users
    count = length(var.user_names) 

    name = var.user_names[count.index]
}
