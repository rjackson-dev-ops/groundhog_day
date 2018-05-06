# Groundhog Day
The purpose of this repo to proovide a AWS Cloudformation template that will provide a working Ruby development environment on an AWS EC2 micro instance. The environment includes:

* rvm 1.29.3
* Ruby 2.3.5
* Python 2.7.6
* aws-cli 1.15.6
* Ubuntu 14.04 LTSA
* Full access to all AWS resources

## Which script should you use?
Use this script: create_dev_env.yaml

This script is included only for reference: create_dev_env.json

I started with the create_dev_env.json script created by our team in 2014 as part of this blog:

* [Set up local development environment](https://stelligent.com/2014/06/13/01-11-set-up-local-development-machines/)

I've left this script in the repo so you can compare the original json script to the current yaml script.

Additionally, this repo contains several devops scripts used for querying/updating system resources.

## Movtivation
Recently, our [Stelligent](https://stelligent.com/) team has worked wth clients where the development environment is "locked down," and we may not have immediate access to AWS resources from our laptops.

This cloudformation script will create a EC2 instance/bastion you can use as a template to create a simple development environment.

In some situations, you made need to recreate this bastion each periodically for security; hence the reason I named this repo [Groundhog Day](https://www.imdb.com/title/tt0107048/).

