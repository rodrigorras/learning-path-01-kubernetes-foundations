# learning-path-01-kubernetes-foundations
ApiMasters Kubernetes Foundations Course Material 

## Minikube Installation Guide

### macOS
1. Install Homebrew if needed:
   - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Install Docker Desktop:
   - `brew install --cask docker`
   - Open Docker Desktop and wait until Docker is running.
3. Install Minikube:
   - `brew install minikube`
4. Start Minikube with the Docker driver:
   - `minikube start --driver=docker`
5. Verify:
   - `minikube status`

> Docker is the recommended macOS driver because it is easy to install, works on Intel and Apple Silicon, and avoids extra VM layer setup.

### Windows
1. Install Chocolatey if needed (elevated PowerShell):
   - `Set-ExecutionPolicy Bypass -Scope Process -Force`
   - `iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex`
2. Install Minikube:
   - `choco install minikube -y`
3. Start Minikube:
   - `minikube start --driver=hyperv`
4. Verify:
   - `minikube status`

> For Windows, Hyper-V is common. If using VirtualBox, replace `--driver=hyperv` with `--driver=virtualbox`.

### Linux
1. Download Minikube:
   - `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64`
2. Install it:
   - `sudo install minikube-linux-amd64 /usr/local/bin/minikube`
3. Start Minikube:
   - `minikube start --driver=docker`
4. Verify:
   - `minikube status`

> If Docker is unavailable, use `--driver=virtualbox` or another supported driver and install that driver first.

### WSL2
1. Ensure WSL2 is installed and your distro is running.
2. Install Docker Desktop for Windows and enable WSL2 integration.
3. In WSL2, install Minikube:
   - `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64`
   - `sudo install minikube-linux-amd64 /usr/local/bin/minikube`
4. Start Minikube from WSL2:
   - `minikube start --driver=docker`
5. Verify:
   - `minikube status`

> WSL2 works best with Docker Desktop and the Docker driver.

### Quick commands
- `minikube start`
- `minikube status`
- `kubectl get nodes`
- `minikube dashboard`
