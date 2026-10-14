# Chapter 2 — Basic Kubectl Commands

**Content type:** Hands-on command reference & practice  
**Duration:** 15 minutes  

---

## Overview

`kubectl` is the command-line interface for communicating with the Kubernetes API server. Almost every command follows a consistent, predictable structure:

```text
kubectl <command> <type> <name> [flags]
```

* **Command (Verb):** What you want to do (`get`, `describe`, `logs`, `apply`, `delete`, `exec`).
* **Type:** The Kubernetes resource type (`nodes`, `pods`, `services`, `deployments`).
* **Name:** The specific resource name (optional when listing all).
* **Flags:** Additional options (e.g. `-n kube-system`, `-o wide`, `-f file.yaml`).

---

## 1. Cluster Information & Node Discovery

Check the health and nodes of your connected cluster:

```bash
# Display the cluster control plane and CoreDNS endpoints
kubectl cluster-info

# List all nodes (worker/control-plane machines) in the cluster
kubectl get nodes

# Show additional details about nodes (IPs, OS image, kernel version)
kubectl get nodes -o wide

# Display supported Kubernetes API resources and short aliases (e.g., po, svc, deploy)
kubectl api-resources
```

---

## 2. Inspecting Resources (`kubectl get`)

`kubectl get` lists resources in tabular format:

```bash
# List all pods in the default namespace
kubectl get pods

# List pods across ALL namespaces in the cluster
kubectl get pods -A
# (or: kubectl get pods --all-namespaces)

# List pods with extended info (Node assigned, Pod IP address)
kubectl get pods -o wide

# List pods showing their assigned labels
kubectl get pods --show-labels

# Filter pods by a label
kubectl get pods -l app=web

# List other resource types
kubectl get services
kubectl get deployments
kubectl get namespaces
```

---

## 3. Deep-Dive Inspection (`kubectl describe`)

When a resource is failing, pending, or misconfigured, `kubectl describe` is your best diagnostic tool. It outputs configuration details and chronological cluster **Events**:

```bash
# Inspect a specific node
kubectl describe node <NODE_NAME>

# Inspect a specific pod
kubectl describe pod <POD_NAME>
```

> **Pro-Tip:** Always scroll to the bottom of `kubectl describe` output—the **Events** section will show scheduling failures, image pull errors (`ImagePullBackOff`), or container crashes (`CrashLoopBackOff`).

---

## 4. Troubleshooting: Logs & Shell Access

### Reading Container Logs (`kubectl logs`)
Inspect what your application is writing to `stdout`/`stderr`:

```bash
# Print existing logs for a pod
kubectl logs <POD_NAME>

# Stream/follow logs in real-time (like tail -f)
kubectl logs -f <POD_NAME>

# View logs from a previous, crashed container instance
kubectl logs -p <POD_NAME>

# If a pod has multiple containers, specify the container name with -c
kubectl logs <POD_NAME> -c <CONTAINER_NAME>
```

### Executing Commands in a Container (`kubectl exec`)
Run a command or open an interactive shell inside a running container:

```bash
# Open an interactive shell inside a container
kubectl exec -it <POD_NAME> -- /bin/sh
# (or /bin/bash if available)

# Run a quick command inside the container without entering a full shell
kubectl exec <POD_NAME> -- env
kubectl exec <POD_NAME> -- ls -la /app
```

---

## 5. Declarative Management (`apply` & `delete`)

Manage resources via manifest files:

```bash
# Create or update resources declaratively from a file
kubectl apply -f manifest.yaml

# Apply all manifests in a directory
kubectl apply -f ./manifests/

# Delete resources defined in a file
kubectl delete -f manifest.yaml

# Delete an individual resource by name
kubectl delete pod <POD_NAME>
kubectl delete deployment <DEPLOYMENT_NAME>
```

---

## 6. Output Formatting (`-o`)

Control the format of `kubectl` command outputs:

```bash
# Standard table with extra columns (IPs, nodes)
kubectl get pods -o wide

# Output full live object in YAML format (great for learning and exporting)
kubectl get pod <POD_NAME> -o yaml

# Output full live object in JSON format
kubectl get pod <POD_NAME> -o json

# Extract a specific field using jsonpath
kubectl get pod <POD_NAME> -o jsonpath='{.status.podIP}'
```

---

## 7. Quick Reference Cheatsheet

| Task | Command |
| :--- | :--- |
| **Cluster info** | `kubectl cluster-info` |
| **List nodes** | `kubectl get nodes -o wide` |
| **List pods (current namespace)** | `kubectl get pods` |
| **List pods (all namespaces)** | `kubectl get pods -A` |
| **Inspect resource & events** | `kubectl describe pod <name>` |
| **Stream pod logs** | `kubectl logs -f <name>` |
| **Open container terminal** | `kubectl exec -it <name> -- sh` |
| **Apply manifest** | `kubectl apply -f <file.yaml>` |
| **Delete manifest** | `kubectl delete -f <file.yaml>` |
| **View recent cluster events** | `kubectl get events --sort-by='.metadata.creationTimestamp'` |

