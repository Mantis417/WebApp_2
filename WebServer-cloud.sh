#cloud-config

# Install .Net Runtime 8.0
runcmd:
  # Register Microsoft repository (which includes .Net Runtime 8.0 package)
  - wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
  - dpkg -i packages-microsoft-prod.deb

  # Install .Net Runtime 8.0
  - apt-get update
  - apt-get install -y aspnetcore-runtime-8.0

# Create a service for the application
write_files:
  - path: /etc/systemd/system/WebApp_2.service
    content: |
      [Unit]
      Description=ASP.NET Web App running on Ubuntu

      [Service]
      WorkingDirectory=/opt/WebApp_2
      ExecStart=/usr/bin/dotnet /opt/WebApp_2/WebApp_2.dll
      Restart=always
      RestartSec=10
      KillSignal=SIGINT
      SyslogIdentifier=WebApp_2
      User=www-data
      Environment=ASPNETCORE_ENVIRONMENT=Production
      Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false
      Environment="ASPNETCORE_URLS=http://*:5000"

      [Install]
      WantedBy=multi-user.target      
    owner: root:root
    permissions: '0644'

systemd:
  units:
    - name: WebApp_2.service
      enabled: true