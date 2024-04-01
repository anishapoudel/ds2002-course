#!/bin/bash


aws s3 cp rotunda.jpg s3://ds2002-ap6acf

presigned_url=$(aws s3 presign --expires-in 604800 s3://ds2002-ap6acf/rotunda.jpg)

echo “Presigned URL:  $presigned_url”
