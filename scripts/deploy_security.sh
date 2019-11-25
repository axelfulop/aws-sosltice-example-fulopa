AWS_DEFAULT_REGION=us-east-1
ENV=predev
AWS_PROFILE=aws-training
SOURCE="$(pwd)/cloudformations"
UUID=$$
BUCKET=aws-afulop-test

PROJECT=AWS-AFULOP-TEST
STACK=$ENV-SECURITY-AFULOP-TEST

echo 'Building SAM package and uploading cloudformation'
sam package --profile $AWS_PROFILE --template-file "${SOURCE}/security.yaml" --output-template-file "security_$UUID.yaml" --s3-bucket $BUCKET --region $AWS_DEFAULT_REGION
sam deploy --profile $AWS_PROFILE --template-file "security_$UUID.yaml" --stack-name $STACK --region $AWS_DEFAULT_REGION --tags Project=$PROJECT --capabilities CAPABILITY_NAMED_IAM --parameter-overrides Environment=$ENV Project=$PROJECT
rm "security_$UUID.yaml"
