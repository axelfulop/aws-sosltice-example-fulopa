# VARIABLES ESTANDAR
AWS_DEFAULT_REGION=us-east-1
ENV=predev
AWS_PROFILE=aws-training
SOURCE="$(pwd)/cloudformations"
FUNCTIONS="$(pwd)/functions"
DEFINITIONS="$(pwd)/stepfunction"
UUID=$$
BUCKET=aws-afulop-test

STACK=$ENV-AFULOP-TEST
PROJECT=AWS-TEST

# SECURITY_GROUP_ID=sg-0ce1ad5c1792a828f
# SUBNET_ID_1=subnet-758a5103
# SUBNET_ID_2=subnet-758a5103

if [ -f "$SOURCE/swagger.yaml" ]; then
    echo 'Uploading swagger to S3'
    aws s3 cp "$SOURCE/swagger.yaml" s3://$BUCKET/Api/$ENV-swagger-$UUID.yaml --profile $AWS_PROFILE
fi

if [ -f "$FUNCTIONS/DynamoGet.zip" ]; then
    echo 'Uploading Lambda DynamoGet to S3'
    aws s3 cp "$FUNCTIONS/DynamoGet.zip" s3://$BUCKET/Functions/DynamoGet.zip --acl public-read-write --profile $AWS_PROFILE
fi

if [ -f "$FUNCTIONS/DynamoPut.zip" ]; then
    echo 'Uploading Lambda DynamoPut to S3'
    aws s3 cp "$FUNCTIONS/DynamoPut.zip" s3://$BUCKET/Functions/DynamoPut.zip --acl public-read-write --profile $AWS_PROFILE
fi

if [ -f "$DEFINITIONS/sf_definition.json" ]; then
    echo 'Uploading StepFunction to S3'
    aws s3 cp "$DEFINITIONS/sf_definition.json" s3://$BUCKET/StepFuncion/sf_definition.json --acl public-read-write --profile $AWS_PROFILE
fi

echo 'Building SAM package and uploading cloudformation'
sam package --profile $AWS_PROFILE --template-file "$SOURCE/template.yaml" --output-template-file "template_$UUID.yaml" --s3-bucket $BUCKET --region $AWS_DEFAULT_REGION
sam deploy --profile $AWS_PROFILE --template-file "template_$UUID.yaml" --stack-name $STACK --region $AWS_DEFAULT_REGION --tags Project=$PROJECT --capabilities CAPABILITY_NAMED_IAM --parameter-overrides UUID=$UUID Environment=$ENV DeployBucket=$BUCKET StackName=$STACK Project=$PROJECT
# SecurityGroupId1=$SECURITY_GROUP_ID SubnetId1=$SUBNET_ID_1 SubnetId2=$SUBNET_ID_2
rm "template_$UUID.yaml"
