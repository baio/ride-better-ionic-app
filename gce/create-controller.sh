#!/bin/sh
gcloud preview container replicationcontrollers delete web-app-controller
gcloud preview container replicationcontrollers create --config-file gce/config/web-app-controller.yml
