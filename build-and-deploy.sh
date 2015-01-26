NODE_ENV=gce_stage gulp build
docker build -t baio/ride-better-web-app .
docker tag baio/ride-better-web-app:latest gcr.io/rb_gce/ride-better-web-app-1
gcloud preview docker push gcr.io/rb_gce/ride-better-web-app-1
gcloud preview container replicationcontrollers resize web-app-controller --num-replicas=0
sh gce/create-controller.sh
