#!/usr/bin/env bash

aws eks update-kubeconfig --name tip-wlan-main
helm plugin install https://github.com/aslafy-z/helm-git --version 0.10.0
sed -i '/wlan-cloud-ucentralgw@/s/ref=.*/ref='master'\"/g' Chart.yaml
sed -i '/wlan-cloud-ucentralgw-ui@/s/ref=.*/ref='main'\"/g' Chart.yaml
sed -i '/wlan-cloud-ucentralsec@/s/ref=.*/ref='main'\"/g' Chart.yaml
sed -i '/wlan-cloud-ucentralfms@/s/ref=.*/ref='main'\"/g' Chart.yaml
export UCENTRALGW_VERSION_TAG=$(echo master | tr '/' '-')
export UCENTRALGWUI_VERSION_TAG=$(echo main | tr '/' '-')
export UCENTRALSEC_VERSION_TAG=$(echo main | tr '/' '-')
export UCENTRALFMS_VERSION_TAG=$(echo main | tr '/' '-')
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm dependency update
helm upgrade --install --create-namespace \
  --namespace ucentral-qualitest --wait --timeout 20m \
  -f /home/centos/Quali/helm/values/values.ucentral-qa.yaml \
  --set ucentralgw.configProperties."rtty\.token"=96181c567b4d0d98c50f127230068fa8 \
  --set ucentralsec.configProperties."authentication\.default\.username"=tip@ucentral.com \
  --set ucentralsec.configProperties."authentication\.default\.password"=13268b7daa751240369d125e79c873bd8dd3bef7981bdfd38ea03dbb1fbe7dcf \
  --set rttys.config.token=96181c567b4d0d98c50f127230068fa8 \
  --set ucentralfms.configProperties."s3\.secret"=b0S6EiR5RLIxoe7Xvz9YXPPdxQCoZ6ze37qunTAI \
  --set ucentralfms.configProperties."s3\.key"=AKIAUG47UZG7R6SRLD7F \
  --set ucentralgw.services.ucentralgw.annotations."external-dns\.alpha\.kubernetes\.io/hostname"=gw-ucentral-qualitest.cicd.lab.wlan.tip.build \
  --set ucentralgw.configProperties."ucentral\.fileuploader\.host\.0\.name"=gw-ucentral-qualitest.cicd.lab.wlan.tip.build \
  --set ucentralgw.configProperties."rtty\.server"=rtty-ucentral-qualitest.cicd.lab.wlan.tip.build \
  --set ucentralgw.configProperties."ucentral\.system\.uri\.public"=https://gw-ucentral-qualitest.cicd.lab.wlan.tip.build:16002 \
  --set ucentralgw.configProperties."ucentral\.system\.uri\.private"=https://gw-ucentral-qualitest.cicd.lab.wlan.tip.build:17002 \
  --set ucentralgw.configProperties."ucentral\.system\.uri\.ui"=https://webui-ucentral-qualitest.cicd.lab.wlan.tip.build \
  --set ucentralsec.services.ucentralsec.annotations."external-dns\.alpha\.kubernetes\.io/hostname"=sec-ucentral-qualitest.cicd.lab.wlan.tip.build \
  --set ucentralsec.configProperties."ucentral\.system\.uri\.public"=https://sec-ucentral-qualitest.cicd.lab.wlan.tip.build:16001 \
  --set ucentralsec.configProperties."ucentral\.system\.uri\.private"=https://sec-ucentral-qualitest.cicd.lab.wlan.tip.build:17001 \
  --set ucentralsec.configProperties."ucentral\.system\.uri\.ui"=https://webui-ucentral-qualitest.cicd.lab.wlan.tip.build \
  --set rttys.services.rttys.annotations."external-dns\.alpha\.kubernetes\.io/hostname"=rtty-ucentral-qualitest.cicd.lab.wlan.tip.build \
  --set ucentralgwui.ingresses.default.annotations."external-dns\.alpha\.kubernetes\.io/hostname"=webui-ucentral-qualitest.cicd.lab.wlan.tip.build \
  --set ucentralgwui.ingresses.default.hosts={webui-ucentral-qualitest.cicd.lab.wlan.tip.build} \
  --set ucentralgwui.public_env_variables.DEFAULT_UCENTRALSEC_URL=https://sec-ucentral-qualitest.cicd.lab.wlan.tip.build:16001 \
  --set ucentralfms.services.ucentralfms.annotations."external-dns\.alpha\.kubernetes\.io/hostname"=fms-ucentral-qualitest.cicd.lab.wlan.tip.build \
  --set ucentralfms.configProperties."ucentral\.system\.uri\.public"=https://fms-ucentral-qualitest.cicd.lab.wlan.tip.build:16004 \
  --set ucentralfms.configProperties."ucentral\.system\.uri\.private"=https://fms-ucentral-qualitest.cicd.lab.wlan.tip.build:17004 \
  --set ucentralfms.configProperties."ucentral\.system\.uri\.ui"=https://webui-ucentral-qualitest.cicd.lab.wlan.tip.build \
  --set-file ucentralgw.certs."restapi-cert\.pem"=resources/certs/cert.pem \
  --set-file ucentralgw.certs."restapi-key\.pem"=resources/certs/key.pem \
  --set-file ucentralgw.certs."websocket-cert\.pem"=resources/certs/cert.pem \
  --set-file ucentralgw.certs."websocket-key\.pem"=resources/certs/key.pem \
  --set-file rttys.certs."restapi-cert\.pem"=resources/certs/cert.pem \
  --set-file rttys.certs."restapi-key\.pem"=resources/certs/key.pem \
  --set-file ucentralsec.certs."restapi-cert\.pem"=resources/certs/cert.pem \
  --set-file ucentralsec.certs."restapi-key\.pem"=resources/certs/key.pem \
  --set-file ucentralfms.certs."restapi-cert\.pem"=resources/certs/cert.pem \
  --set-file ucentralfms.certs."restapi-key\.pem"=resources/certs/key.pem \
  --set ucentralgw.images.ucentralgw.tag=master \
  --set ucentralgwui.images.ucentralgwui.tag=main \
  --set ucentralsec.images.ucentralsec.tag=main \
  --set ucentralfms.images.ucentralfms.tag=main \
  tip-ucentral .
