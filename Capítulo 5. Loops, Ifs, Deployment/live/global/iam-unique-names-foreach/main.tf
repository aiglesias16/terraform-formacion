provider "aws" {
    region = "us-east-2"
}

resource "aws_iam_user" "users" {
    ## We have to parse the list into a set to use for_each
    for_each = toset(var.user_names)

    name     = each.value
}