# ロールを受け入れる対象を定義
# 今回はLambdaサービスが受け入れる
data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    # デフォルトAllow
    effect = "Allow"
    # Statement ID
    sid = ""
  }
}

# ロールに付与するポリシー
# 今回は全Lambdaリソースに対するAll actions (lambda:*)
data "aws_iam_policy_document" "example_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

# Package the Lambda function code
data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/python/test.py"
  output_path = "${path.module}/python/function.zip"
}

resource "aws_iam_role" "lambda" {
  name               = "labmda_all_allow"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}

resource "aws_iam_role_policy" "lambda" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.example_policy.json
}

resource "aws_lambda_function" "example" {
  role = aws_iam_role.lambda.arn

  runtime          = "python3.13"
  function_name    = "example_function"
  handler          = "test.handler"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_sha256
}
