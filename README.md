# nubis-mediawiki
This is a Nubis deployment of the [MediaWiki](https://www.mediawiki.org/) application. The purpose of this project is to demonstrate an example of a php deployment. This repository is an example of a "deployment repository", in other words a repository that does not contain any application code.

## Repository Structure
The structure of the repository is quite simple. The application is installed as a git submodule. There is a directory called *nubis* which contains all of the nubis modules necessary to deploy the application.


## Deployment Process
There are a few steps necessary to deploy this project. While these steps are listed in order to build and deploy, it is not necessary to run the build steps if you use and AMI that we have already created. This means you can skip the Nubis-Builder steps and jump straight to the [CloudFormation](#cloudformation) section.


### Puppet
We are using [puppet](http://puppetlabs.com/) in this example to bootstrap up our VM. Puppet installs and configures services such as *Apache* and *MySql*. We are using the [nubis-puppet](https://github.com/Nubisproject/nubis-puppet) project for our module collection. This is conveniently installed on the *base image* (built by [nubis-base](https://github.com/Nubisproject/nubis-base)) that we are going to use as the starting image for our Nubis-Builder build in the next step.


### Nubis-Builder
[Nubis-Builder](https://github.com/Nubisproject/nubis-builder) is the piece that will build our AMI. It uses [Packer](https://packer.io) under the hood. It is made up of a few pieces:

1. The [provisioners.json](nubis/builder/provisioners.json) file which contains:
        * One or more *provisioners* statements for any bootstrapping commands for the application
2. A [project.json](nubis/builder/project.json) file which contains things like:
    * Project description
    * Project Version

To run nubis-builder, from the repository root you put your local copy of nubis-builder in your path and simply call nubis-builder like so:
```bash
PATH=$builder_prefix/bin:$PATH
nubis-builder build 
```
This takes around *11m 18.488s* to complete.


### CloudFormation
The next step is to take the shiny new AMI that Packer built and deploy it. This is where [CloudFormation](http://aws.amazon.com/cloudformation/) comes into play. CloudFormation is our infrastructure deployment framework. It consists of a few files:

1. [parameters.json](nubis/cloudformation/parameters.json-dist) describes the inputs you need to provide.
1. [main.json](nubis/cloudformation/main.json) describes the resources necessary to run the application.

In your nubis/cloudformation directlry copy the [parameters.json-dist](nubis/cloudformation/parameters.json-dist) file to parameters.json and edit it as follows:

* [ServiceName](https://github.com/Nubisproject/nubis-mediawiki/blob/master/nubis/cloudformation/parameters.json-dist#L3) should be set to something unique like "jdmediawiki".
* [Environment](https://github.com/Nubisproject/nubis-mediawiki/blob/master/nubis/cloudformation/parameters.json-dist#L7) should be set to "sandbox".
* [KeyName](https://github.com/Nubisproject/nubis-mediawiki/blob/master/nubis/cloudformation/parameters.json-dist#L11) should be set to the name of the key you uploaded to AWS.
* [TechnicalOwner](https://github.com/Nubisproject/nubis-mediawiki/blob/master/nubis/cloudformation/parameters.json-dist#L15) should be set to a valid email address for you.
* [AmiId](https://github.com/Nubisproject/nubis-mediawiki/blob/master/nubis/cloudformation/parameters.json-dist#L19) should be set to either the AMI you built in the previous step or to a value in the following table if you did not build your own AMI.

 | Environment | AMI Id       |
 |-------------|--------------|
 | Sandbox     | ami-6f99ad5f |
 | Dev         |              |
 | Prod        |              |

This can now be deployed using the AWS cli tools. For commands see the [README](nubis/cloudformation/README.md) in the nubis/cloudformation directory

## Quick Commands
```bash
git clone https://github.com/nubisproject/nubis-mediawiki.git

git submodule update --init --recursive

nubis-builder build 

cp nubis/cloudformation/parameters.json-dist nubis/cloudformation/parameters.json

vi nubis/cloudformation/parameters.json

aws cloudformation create-stack --stack-name nubis-mediawiki --template-body file://nubis/cloudformation/main.json --parameters file://nubis/cloudformation/parameters.json
```