# kms.tf
resource "aws_kms_key" "eks" {
  description         = "KMS key for EKS cluster encryption"
  enable_key_rotation = true
  
  tags = {
    Name        = "eks-encryption-key"
    Environment = var.environment
    Application = "myapp"
  }
}

resource "aws_kms_alias" "eks" {
  name          = "alias/eks-encryption-key"
  target_key_id = aws_kms_key.eks.key_id
}

# KMS key policy (optional - AWS provides a default policy)
resource "aws_kms_key_policy" "eks" {
  key_id = aws_kms_key.eks.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-policy-eks"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow EKS Service"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}