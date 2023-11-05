#!/bin/bash

DEPLOY_SCRIPT_PATH="/home/brazovsky/Desktop/VizorGames/task1.sh"

cat <<EOL | sudo tee /etc/systemd/system/stack-deployment.service
[Unit]
Description=Stack Deployment Service
After=network.target

[Service]
Type=simple
ExecStart=$DEPLOY_SCRIPT_PATH
Restart=always
WorkingDirectory=$(dirname $DEPLOY_SCRIPT_PATH)

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable stack-deployment
systemctl start stack-deployment
systemctl status stack-deployment
