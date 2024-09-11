#!/bin/bash

# Variables
REPO_URL="https://github.com/your-username/your-repository"  # Replace with your GitHub repo URL
GITHUB_PAT="your_github_personal_access_token"               # Replace with your GitHub PAT
RUNNER_NAME="webserver-runner"
RUNNER_DIR="/home/ubuntu/actions-runner"                     # Directory for the GitHub runner
LABELS="webserver,linux"
GITHUB_USER="your-username"                                  # GitHub username or org
REPO_NAME="your-repository"                                  # Repository name

# Install dependencies
apt update && apt install -y curl jq

# Get registration token
REG_TOKEN=$(curl -s -X POST -H "Authorization: token $GITHUB_PAT" \
    https://api.github.com/repos/$GITHUB_USER/$REPO_NAME/actions/runners/registration-token | jq -r .token)

# Create a directory for the runner
mkdir -p $RUNNER_DIR
cd $RUNNER_DIR

# Download the GitHub runner package
curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v2.308.0/actions-runner-linux-x64-2.308.0.tar.gz

# Extract the package
tar xzf ./actions-runner-linux-x64.tar.gz

# Install the runner
./config.sh --url $REPO_URL --token $REG_TOKEN --name $RUNNER_NAME --labels $LABELS --unattended --replace

# Set up the runner as a service
./svc.sh install

# Start the service
./svc.sh start

# Enable the service to start on boot
systemctl enable actions.runner.$GITHUB_USER.$REPO_NAME.$RUNNER_NAME.service