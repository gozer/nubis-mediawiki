Example command to deploy:

aws cloudformation create-stack --stack-name dpaste-1-instances --template-body "`cat mediawiki.json`" --parameters ParameterKey=EnvType,ParameterValue=sandbox
