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
  source_file = "${path.module}/layer-python/function/lambda_function.py"
  output_path = "${path.module}/layer-python/function/function.zip"
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

# https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/python-layers.html#python-layer-packaging
# この手順でパッケージ作成
# 1-install.sh実行で、create_layer/python/lib/python3.7/site-packagesが作成される
# ディレクトリのpythonバージョンをLabmdaのランタイムバージョンに合わせる
resource "aws_lambda_layer_version" "example" {
  layer_name = "python-requests-layer"

  filename                 = "${path.module}/layer_content.zip"
  source_code_hash         = "${path.module}/layer_content.zip"
  compatible_runtimes      = ["python3.13"]
  compatible_architectures = ["arm64"]
}

resource "aws_lambda_function" "example" {
  role = aws_iam_role.lambda.arn

  runtime          = "python3.13"
  function_name    = "example_function"
  handler          = "lambda_function.lambda_handler"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_sha256

  layers = [aws_lambda_layer_version.example.arn]
}
