#!/bin/bash

selectedRegion=$1

echo "aws configure set region ${selectedRegion}"
echo "export region=${selectedRegion}"
echo "export AWS_REGION=${selectedRegion}"
echo "export AWS_DEFAULT_REGION=${selectedRegion}"
echo "export REGION=${selectedRegion}"
echo "aws configure --profile stel set region ${selectedRegion}"
echo "aws configure --profile sfh set region ${selectedRegion}"