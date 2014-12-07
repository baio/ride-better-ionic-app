#!/bin/sh
gcloud preview container services delete web-app-service
gcloud preview container services create --config-file config/web-app-service.yml