FROM microsoft/windowsservercore

ADD hosts "C:\Windows\System32\drivers\etc"
ARG CHROME_VERSION=62.0.3202.94 
ARG USER=admin
ARG PASSWORD=password

#ARG header="@{ Authorization = 'Basic YWRtaW46cGFzc3dvcmQ=' }"
ARG url=http://<URL-to-download-vstest-agent>/vstf_testagent.exe

SHELL ["powershell"]
RUN Invoke-WebRequest -Uri $ENV:url -Headers @{ Authorization = 'Basic YWRtaW46cGFzc3dvcmQ=' }  -Method "Get" -ContentType "application/zip" -UseBasicParsing -OutFile "app.exe"
RUN powershell.exe -Command Start-Process C:\\app.exe -ArgumentList '/quiet' -Wait
RUN powershell.exe -command mkdir tools
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN choco install googlechrome --version $ENV:CHROME_VERSION  --ignore-checksums -force -v -y
