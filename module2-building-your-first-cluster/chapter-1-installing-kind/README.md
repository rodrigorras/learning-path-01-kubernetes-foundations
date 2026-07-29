# learning-path-01-kubernetes-foundations
ApiMasters Kubernetes Foundations Course Material 

## Kind Installation Guide

> Tip: Kind's official documentation provides the most up-to-date installation instructions. Visit https://kind.sigs.k8s.io/docs/user/quick-start/#installation to generate the latest install and start commands for your OS.

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
3. Install Kind:
```bash
brew install kind
```   

4. Install Kubectl:
```bash
brew install kubectl
```

5. Create a cluster:
```bash
kind create cluster
```
6. Verify:
```bash
kubectl cluster-info --context kind-kind
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
3. Install Kind:
```powershell
choco install kind -y
```
4. Install Kubectl:
```powershell
choco install kubernetes-cli -y
```
5. Create a cluster:
```powershell
kind create cluster
```
6. Verify:
```powershell
kubectl cluster-info --context kind-kind
```

> Docker is the recommended driver on Windows when Docker Desktop is available.

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
2. Download Kind:
```bash
# For x86_64 Linux:
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
# For ARM64 Linux:
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-arm64
```
3. Install it:
```bash
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```
4. Install Kubectl:
```bash
sudo snap install kubectl --classic
```
5. Create a cluster:
```bash
kind create cluster
```
6. Verify:
```bash
kubectl cluster-info --context kind-kind
```

> Docker is the required driver for Kind.

### WSL2
1. Ensure WSL2 is installed and your distro is running.
2. Install Docker Desktop for Windows, enable WSL2 integration, or download it directly from https://www.docker.com/products/docker-desktop.
3. In WSL2, install Kind:
```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```
4. Install Kubectl:
```bash
sudo snap install kubectl --classic
```
5. Create a cluster from WSL2:
```bash
kind create cluster
```
6. Verify:
```bash
kubectl cluster-info --context kind-kind
```

> WSL2 works best with Docker Desktop.

### Creating a Multi-Node Cluster
By default, `kind create cluster` will create a single-node cluster. To create a cluster with multiple nodes (e.g., one control-plane and two workers), you can use a YAML configuration file.

1.  Create a file named `kind-cluster-config.yaml` with the following content:
    ```yaml
    # three node (two workers) cluster config
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    nodes:
    - role: control-plane
    - role: worker
    - role: worker
    ```

2.  Create the cluster with the config file:
    ```bash
    kind create cluster --config kind-cluster-config.yaml
    ```

3.  You can see the nodes in your cluster with `kubectl get nodes`.

### Quick commands
- `kind create cluster`
- `kind get clusters`
- `kubectl cluster-info --context kind-kind`
- `kind delete cluster`
