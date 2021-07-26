# Git Large File Strategy

## Install Git LFS
[Install Git LFS](https://docs.github.com/en/github/managing-large-files/versioning-large-files/installing-git-large-file-storage)


```

# Used package cloud

curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

sudo apt-get install git-lfs
git lfs install



```

### Remove existing large file from local repo

```

# Delete files from repo and file systems
# Not a good option for me had to download files again
#git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch *.pdf'

# Remove all files from index, will add them back later
git rm -r -f --cached .

```

## Find large file types

```

find . -xdev -type f -size +1M

./Resources/AWS Certified Solutions Architect - Professional 2020 Chapter 1-4.pdf
./Resources/Chapter 5 Links/aws-migration-whitepaper.pdf
./Resources/Chapter 5 Links/migrating-applications-to-aws.pdf
./Resources/AWS Certified Solutions Architect - Professional 2020 Chapter 5-10.pdf
./Resources/Chapter 8 Links/practicing-continuous-integration-continuous-delivery-on-AWS.pdf
./Resources/Chapter 6 Links/microservices-on-aws.pdf
./Resources/Chapter 6 Links/performance-at-scale-with-amazon-elasticache.pdf
./Resources/Chapter 7 Links/Backup_and_Recovery_Approaches_Using_AWS.pdf
./Resources/Chapter 7 Links/AWS-Reliability-Pillar.pdf
./Resources/Chapter 3 Links/integrating-aws-with-multiprotocol-label-switching.pdf
./Resources/Chapter 3 Links/aws-vpc-connectivity-options.pdf
./Resources/Chapter 2 Links/Multi_Tenant_SaaS_Storage_Strategies.pdf
./Resources/Chapter 2 Links/performance-at-scale-with-amazon-elasticache.pdf


```

## Assign large file types to lfs

```

git lfs track "*.pdf"
git lfs track "*.mp3"
git lfs migrate import --include="*.pdf"

```

## Add file now and commit

```
git add -A

git commit -am "Pushing big files"

git push

```