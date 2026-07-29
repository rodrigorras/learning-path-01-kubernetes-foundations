# Installing Docker Desktop on Mac

This section provides instructions for installing Docker Desktop on macOS.

## Prerequisites

*   macOS 10.15 or newer.
*   Intel chip or Apple Silicon.

## Installation Steps

1.  **Download Docker Desktop:**
    *   Go to the [Docker Desktop for Mac download page](https://docs.docker.com/desktop/install/mac-install/).
    *   Download the installer appropriate for your Mac (Intel or Apple Silicon).

2.  **Install Docker Desktop:**
    *   Double-click the `Docker.dmg` file.
    *   Drag the Docker icon to the Applications folder.
    *   Open Docker Desktop from the Applications folder.

3.  **Start Docker Desktop:**
    *   Follow the on-screen instructions to complete the installation and initial setup.
    *   Docker Desktop will start automatically after installation. You will see the Docker icon in the menu bar.

4.  **Verify Installation:**
    *   Open your terminal and run the following commands to verify that Docker is installed correctly:
        ```bash
        docker --version
        ```
    *   You should see the version information for Docker.

## Enabling Kubernetes

1.  **Open Docker Desktop Preferences:**
    *   Click on the Docker icon in the menu bar and go to "Preferences" (or "Settings").
2.  **Navigate to Kubernetes Section:**
    *   In the Preferences window, select the "Kubernetes" tab.
3.  **Enable Kubernetes:**
    *   Check the "Enable Kubernetes" box.
    *   Ensure "Show system containers (advanced)" is unchecked.
    *   Click "Apply & Restart". Docker Desktop will restart and begin provisioning the Kubernetes cluster. This may take a few minutes.

## Verifying Kubernetes Installation

1.  **Check Kubernetes Status:**
    *   Once Docker Desktop has restarted, the Kubernetes status indicator at the bottom left of the Docker Desktop dashboard should show "Kubernetes is running".
2.  **Verify kubectl Context:**
    *   Open your terminal and run the following command:
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

You are now ready to use Docker Desktop with Kubernetes on your Mac!

