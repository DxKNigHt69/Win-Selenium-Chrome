# Use a base image that includes Windows
ARG VERSION=4.8-windowsservercore-ltsc2019
FROM mcr.microsoft.com/dotnet/framework/runtime:${VERSION}

# Install Chocolatey for easier package management
RUN Powershell Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN powershell MKDIR C:\selenium; \
# Download Selenium Server and ChromeDriver
Invoke-WebRequest -Uri "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.11.0/selenium-server-4.11.0.jar" -OutFile "C:\selenium\selenium-server-4.11.0.jar";
# Expand-Archive -Path "C:\selenium\selenium-server-4.11.0.zip" -DestinationPath "C:\selenium\tempdx" ; \
# Copy-Item -Path "C:\selenium\tempdx\selenium-server-4.11.0.jar" -Destination "C:\selenium" -Recurse \
# Remove-Item -Path "C:\selenium\tempdx" -Force -Recurse;

RUN powershell Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/org/seleniumhq/selenium/selenium-http-jdk-client/4.11.0/selenium-http-jdk-client-4.11.0.jar" -OutFile "C:\selenium\selenium-http-jdk-client-4.11.0.jar";

# Install chromedriver v115
RUN powershell Invoke-WebRequest -Uri "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/116.0.5845.96/win64/chromedriver-win64.zip" -OutFile "C:\selenium\chromedriver-win64.zip"; \
Expand-Archive -Path "C:\selenium\chromedriver-win64.zip" -DestinationPath "C:\selenium" ; \
Copy-Item -Path "C:\selenium\chromedriver-win64\*" -Destination "C:\selenium" -Recurse; \
Remove-Item -Path "C:\selenium\chromedriver-win64" -Force -Recurse

# Install Google Chrome latest v115.0.5790.170
RUN choco install googlechrome --confirm

# Set the URL for the JDK installer
RUN choco install oracle17jdk -y
# Set the JAVA_HOME environment variable  -no need

# Set working directory
WORKDIR "C:\\selenium"


 