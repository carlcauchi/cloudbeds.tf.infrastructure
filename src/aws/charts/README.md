helm s3 init s3://cloudbeds-helmrepo/stable/cloudbeds.app.myapp
helm s3 init s3://cloudbeds-helmrepo/stable/cloudbeds.app.hisapp
helm s3 init s3://cloudbeds-helmrepo/stable/cloudbeds.app.herapp

helm plugin install https://github.com/hypnoglow/helm-s3.git

aws s3 ls s3://cloudbeds-helmrepo/stable/cloudbeds.app.myapp
aws s3 ls s3://cloudbeds-helmrepo/stable/cloudbeds.app.hisapp
aws s3 ls s3://cloudbeds-helmrepo/stable/cloudbeds.app.herapp

helm repo add stable-cloudbeds.app.myapp s3://cloudbeds-helmrepo/stable/cloudbeds.app.myapp/
helm repo add stable-cloudbeds.app.hisapp s3://cloudbeds-helmrepo/stable/cloudbeds.app.hisapp/
helm repo add stable-cloudbeds.app.herapp s3://cloudbeds-helmrepo/stable/cloudbeds.app.herapp/

helm create cloudbeds.app.myapp-chart
helm create cloudbeds.app.hisapp-chart
helm create cloudbeds.app.herapp-chart

helm lint

helm package cloudbeds.app.myapp-chart --debug
helm package cloudbeds.app.hisapp-chart --debug
helm package cloudbeds.app.herapp-chart --debug

helm s3 push cloudbeds.app.myapp-chart-0.1.0.tgz stable-cloudbeds.app.myapp
helm s3 push cloudbeds.app.hisapp-chart-0.2.0.tgz stable-cloudbeds.app.hisapp
helm s3 push cloudbeds.app.herapp-chart-0.3.0.tgz stable-cloudbeds.app.herapp

helm search repo stable-cloudbeds.app.