# Installing Docker Desktop on Windows

This section provides instructions for installing Docker Desktop on Windows.

## Prerequisites

*   Windows 10 64-bit: Pro, Enterprise, or Education (Build 19041 or later).
*   WSL 2 backend.

## Installation Steps

1.  **Download Docker Desktop:**
    *   Go to the [Docker Desktop for Windows download page](https://docs.docker.com/desktop/install/windows-install/).
    *   Download the `Docker Desktop Installer.exe` file.

2.  **Install Docker Desktop:**
    *   Double-click the installer executable to run it.
    *   Follow the installation wizard. Ensure that "Install required Windows components for WSL 2" is checked.
    *   Authorize the installer when prompted (requires administrator privileges).
    *   When the installation is complete, click "Close" and then restart your computer if prompted.

3.  **Start Docker Desktop:**
    *   Search for "Docker Desktop" in the Windows search bar and open it.
    *   Accept the terms of service.
    *   Docker Desktop will start automatically. You will see the Docker icon in the system tray.

4.  **Verify Installation:**
    *   Open PowerShell or Command Prompt and run the following commands to verify that Docker is installed correctly:
        ```bash
        docker --version
        ```
    *   You should see the version information for Docker.

## Enabling Kubernetes

1.  **Open Docker Desktop Settings:**
    *   Right-click on the Docker icon in the system tray and select "Settings".
2.  **Navigate to Kubernetes Section:**
    *   In the Settings window, select the "Kubernetes" tab.
3.  **Enable Kubernetes:**
    *   Check the "Enable Kubernetes" box.
    *   Ensure "Show system containers (advanced)" is unchecked.
    *   Click "Apply & Restart". Docker Desktop will restart and begin provisioning the Kubernetes cluster. This may take a few minutes.

## Verifying Kubernetes Installation

1.  **Check Kubernetes Status:**
    *   Once Docker Desktop has restarted, the Kubernetes status indicator at the bottom left of the Docker Desktop dashboard should show "Kubernetes is running".
2.  **Verify kubectl Context:**
    *   Open PowerShell or Command Prompt and run the following command:
        ```bash
        kubectl config get-contexts
        ```
    *   You should see a context named `docker-desktop` (or similar) listed, and it should be marked as the current context.
3.  **Check Cluster Nodes:**
    *   Verify that the Kubernetes cluster nodes are running:
        ```bash
        kubectl get nodes
        ```
    *   You should see a `docker-desktop` node with a status of `Ready`.

You are now ready to use Docker Desktop with Kubernetes on your Windows machine!

