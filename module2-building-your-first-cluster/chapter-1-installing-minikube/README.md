# learning-path-01-kubernetes-foundations
ApiMasters Kubernetes Foundations Course Material 

## Minikube Installation Guide

> Tip: Minikube features an official command builder for your platform. Visit https://minikube.sigs.k8s.io/docs/start/ to generate the latest install and start commands for your OS, architecture, and driver.

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
   - Or download Docker Desktop directly from https://www.docker.com/products/docker-desktop
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
# For x86_64 Linux:
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
# For ARM64 Linux:
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
```
3. Install it:
```bash
# For x86_64 Linux:
sudo install minikube-linux-amd64 /usr/local/bin/minikube
# For ARM64 Linux:
sudo install minikube-linux-arm64 /usr/local/bin/minikube
```
4. Clean up installer files:
```bash
rm -f minikube-linux-amd64 minikube-linux-arm64
```
5. Start Minikube:
```bash
minikube start --driver=docker
```
6. Verify:
```bash
minikube status
```

> Docker is the preferred Linux driver for Minikube. If Docker is unavailable, use `--driver=virtualbox` or another supported driver after installing that driver first.

### WSL2
1. Ensure WSL2 is installed and your distro is running.
2. Install Docker Desktop for Windows, enable WSL2 integration, or download it directly from https://www.docker.com/products/docker-desktop.
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

### Creating a Multi-Node Cluster
Minikube can create a cluster with multiple nodes by using the `--nodes` flag with the `minikube start` command.

1.  To create a cluster with 3 nodes (1 control-plane and 2 workers), run the following command:
    ```bash
    minikube start --nodes 3 --driver=docker
    ```
    This will provision a multi-node cluster.

2.  You can see the nodes in your cluster with `kubectl get nodes`.

3.  To add a node to an existing cluster, you can use the `minikube node add` command.

### Quick commands
- `minikube start`
- `minikube status`
- `kubectl get nodes`
- `minikube dashboard`
