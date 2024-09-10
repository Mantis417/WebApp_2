#!/bin/bash

#Variablar
ResourceGroup="exam2"
Location="norwayeast"
Template="Template.json"
SSHPath="$HOME/.ssh/id_rsa.pub"
ReverseProxy="@Reverse-cloud.sh"
WebServer="@WebServer-cloud.sh"

# Skapar resursgrupp
az group create \
  --name $ResourceGroup \
  --location $Location

# Deploy ARM template.
az deployment group create \
  --resource-group $ResourceGroup \
  --template-file $Template \
  --parameters adminSshKey="$(cat $SSHPath)" \
  --parameters WebServer-Cloud="$WebServer" \
  --parameters ReverseProxy-Cloud="$ReverseProxy"