data "aws_iam_policy" "pvre_policy" {
    arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

// ec2
resource "aws_iam_role_policy_attachment" "pvre_attach_ec2" {
  role       = aws_iam_role.tf_ec2_service_role.name
  policy_arn = data.aws_iam_policy.pvre_policy.arn
}


// https://medium.com/geekculture/terraform-how-to-use-dynamic-blocks-when-conditionally-deploying-to-multiple-environments-57e63c0a2b56