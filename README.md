# nubis-mediawiki
This is a Nubis deployment of the [MediaWiki](https://www.mediawiki.org/) application. The purpose of this project is to demonstrate an example of a php deployment. This repository is an example of a "deployment repository", in other words a repository that does not contain any application code.

## Repository Structure
The structure of the repository is quite simple. The application is installed as a git submodule. There is a directory called *nubis* which contains all of the nubis modules necessary to deploy the application.


## Deployment Process
Currently there are a few steps necessary to deploy this project. We intend to simplify this process going forward. While these steps are listed in order to build and deploy, it is typically not necessary to run the build steps. This means you can skip the Nubis-Builder steps and jump straight to the [Terraform](#terraform) section.


### Puppet
We are using [puppet](http://puppetlabs.com/) in this example to bootstrap up our VM. Puppet installs and configures services such as *Apache* and *MySql*. We are using the [nubis-puppet](https://github.com/Nubisproject/nubis-puppet) project for our module collection. This is conveniently installed on the *base image* (built by [nubis-base](https://github.com/Nubisproject/nubis-base)) that we are going to use as the starting image for our Packer build in the next step.


### Nubis-Builder
[Nubis-Builder](https://github.com/Nubisproject/nubis-builder) is the piece that will build our AMI. It is made up of a few pieces:

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


### Terraform
The next step is to take the shiny new AMI that Packer built and deploy it. This is where [Terraform](https://www.terraform.io/) comes into play. Terraform is our infrastructure deployment framework, but not to worry it is really not as complicated as its name implies. It consists of a few files:

1. [inputs.tf](nubis/terraform/inputs.tf) simply lists the variables you might need to provide
2. [main.tf](nubis/terraform/main.tf) is where the real heavy lifting takes place. This is where you describe your infrastructure. Thisgs like EC2 instances, security groups, ELBs and so on.
3. [outputs.tf](nubis/terraform/outputs.tf) describes what information from the build we want to make available (via Consul) for later reference.
4. [terraform.tfvars](nubis/terraform/terraform.tfvars-dist) is where you will set your AWS credentials and such.

To run terraform, from the repository root you first need to create your *terraform.tfvars* file, for which there is a template provided (terraform.tfvars-dist). After which you simply call terraform like so:

To see what resources will be created, destroyed, or refreshed:
```bash
terraform plan -var-file=nubis/terraform/terraform.tfvars nubis/terraform/
```
To apply the plan (do the work)
```bash
terraform apply -var-file=nubis/terraform/terraform.tfvars nubis/terraform/
```
This takes around *0m 35.162s*, which you can see is quite speedy.


## Quick Commands
Edit *nubis/terraform/terraform.tfvars*
```bash
git clone https://github.com/nubisproject/nubis-mediawiki.git

git submodule update --init --recursive

nubis-builder build 

terraform apply -var-file=nubis/terraform/terraform.tfvars nubis/terraform/
```


## TODO
I have a fair bit of work to do before this project is ready for use. Some of the outstanding tasks are:
* Address route 53 SOA issue
* Load data to rds instance
* Configure s3 bucket
* Create autoscailing group
* confd integration (/etc/nubis-confog/)
* Finish migrator instance script
* Play with code install with puppet
* Autogenerate
 * db_password
 * app_secret_key
 * app_upgrade_key
* Fsix security group dependancy issues