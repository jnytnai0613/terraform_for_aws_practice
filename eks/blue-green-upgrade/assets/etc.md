# ALB Controller
$ helm repo add eks https://aws.github.io/eks-charts
$ helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=green

# External DNS
$ kubectl apply -f terraform_for_aws_practice/examples/kubernetes-eks/blue-green-upgrade/assets/external-dns/external-dns.yaml

# コード
```python
from fastapi import FastAPI
import boto3

app = FastAPI()

@app.get("/")
def read_root():
    dynamodb = boto3.client("dynamodb", region_name="ap-northeast-1")
    response = dynamodb.scan(
        TableName="test-dynamodb",
    )
    return response["Items"]
```

# Dockerfile
```docker
FROM python:3.11-slim

WORKDIR /app

RUN pip install --upgrade pip
RUN pip install boto3 fastapi uvicorn

COPY ./app/ .

CMD ["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "8080"]
```

# DynamoDBデータ投入
$ aws dynamodb put-item --table-name test-dynamodb --item '{"UserId": {"S": "3"}}'