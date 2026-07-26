# learning-path-01-kubernetes-foundations
ApiMasters Kubernetes Foundations Course Material 

## Minikube Installation Guide

### macOS
1. Install Homebrew if needed:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
2. Install Docker Desktop:
```bash
brew install --cask docker
```
   - Open Docker Desktop and wait until Docker is running.
3. Install Minikube:
```bash
brew install minikube
```
4. Start Minikube with the Docker driver:
```bash
minikube start --driver=docker
```
5. Verify:
```bash
minikube status
```

> Docker is the recommended macOS driver because it is easy to install, works on Intel and Apple Silicon, and avoids extra VM layer setup.

### Windows
1. Install Chocolatey if needed (elevated PowerShell):
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex
```
2. Install Docker Desktop:
```powershell
choco install docker-desktop -y
```
   - Open Docker Desktop and wait until Docker is running.
3. Install Minikube:
```powershell
choco install minikube -y
```
4. Start Minikube:
```powershell
minikube start --driver=docker
```
5. Verify:
```powershell
minikube status
```

> Docker is the recommended driver on Windows when Docker Desktop is available. If you need Hyper-V instead, use `minikube start --driver=hyperv`.

### Linux
1. Install Docker Engine:
```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
# Log out and log back in, or open a new terminal and run newgrp docker to apply group membership.
newgrp docker
docker ps
```
2. Download Minikube:
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```
3. Install it:
```bash
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```
4. Start Minikube:
```bash
minikube start --driver=docker
```
5. Verify:
```bash
minikube status
```

> Docker is the preferred Linux driver for Minikube. If Docker is unavailable, use `--driver=virtualbox` or another supported driver after installing that driver first.

### WSL2
1. Ensure WSL2 is installed and your distro is running.
2. Install Docker Desktop for Windows and enable WSL2 integration.
3. In WSL2, install Minikube:
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```
4. Start Minikube from WSL2:
```bash
minikube start --driver=docker
```
5. Verify:
```bash
minikube status
```

> WSL2 works best with Docker Desktop and the Docker driver.

### Quick commands
- `minikube start`
- `minikube status`
- `kubectl get nodes`
- `minikube dashboard`
