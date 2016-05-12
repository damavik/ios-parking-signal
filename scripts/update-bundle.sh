#!/bin/sh
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in scripts/profile/AdHoc.mobileprovision.enc -d -a -out scripts/profile/AdHoc.mobileprovision
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in scripts/certs/dist.cer.enc -d -a -out scripts/certs/dist.cer
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in scripts/certs/dist.p12.enc -d -a -out scripts/certs/dist.p12
