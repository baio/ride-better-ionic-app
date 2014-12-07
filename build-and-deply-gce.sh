NODE_ENV=gce_stage gulp build
sudo docker build -t baio/ride-better-web-app .
sudo docker push baio/ride-better-web-app
gcloud preview container replicationcontrollers resize web-app-controller --num-replicas=0
sh gce/create-controller.sh
