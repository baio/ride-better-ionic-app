#!/bin/sh
gcloud preview container services delete web-app-service
gcloud preview container services create --config-file gce/config/web-app-service.json