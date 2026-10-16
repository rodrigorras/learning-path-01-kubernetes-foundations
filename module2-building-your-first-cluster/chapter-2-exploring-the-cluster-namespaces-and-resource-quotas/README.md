# Navigating Namespaces and Managing Resource Quotas in Kubernetes

This tutorial covers how to inspect cluster contexts and namespaces, create a deployment, set up a resource quota to limit pod creation, and troubleshoot quota limits using Kubernetes CLI tools (`kubectx`, `kubens`, and `kubectl`).

---

## Step 1: Inspect Contexts and Namespaces

Before managing resources, verify your active context and existing namespaces.

### Check Active Cluster Context
Displays the active context (e.g., default):
```bash
kubectx
```

### List Available Namespaces
Lists all available namespaces in the current cluster:
```bash
kubens
```

### Inspect Pods in System Namespace
Lists pods running in the core `kube-system` namespace:
```bash
kubectl get pods -n kube-system
```

---

## Step 2: Create a New Namespace and Deployment

### Create a Namespace
Creates a new namespace named `demo-space`:
```bash
kubectl create ns demo-space
```

### Verify Namespace Creation
Confirms that the new namespace is listed:
```bash
kubens
```

### Create NGINX Deployment
Creates an NGINX deployment with 2 replicas in `demo-space`:
```bash
kubectl create deployment -n demo-space nginx --image nginx --replicas 2
```

### Verify Deployment Status
Checks the status of the newly created deployment:
```bash
kubectl get deployments -n demo-space
```

---

## Step 3: Enforce a Pod Resource Quota

Resource quotas allow you to restrict the total resource consumption per namespace.

### Create a Hard Pod Limit Quota
Creates a hard limit of 2 pods for the `demo-space` namespace:
```bash
kubectl create quota pod-limit --hard=pods=2 -n demo-space
```

### Attempt to Scale Beyond Quota
Attempts to scale the deployment to 3 replicas:
```bash
kubectl scale deployment/nginx --replicas 3 -n demo-space
```

### Check Deployment Status
Checks the deployment status to observe that it fails to scale up to 3 ready replicas due to the quota limit:
```bash
kubectl get deployment -n demo-space
```

---

## Step 4: Troubleshoot Quota Failures

When a deployment fails to scale, check the underlying ReplicaSet for detailed event logs.

### Describe ReplicaSet Events
Inspects the ReplicaSet in the namespace to reveal why new pods cannot be scheduled:
```bash
kubectl describe rs -n demo-space
```

The output will display a `FailedCreate` event indicating that the quota limit of 2 pods was exceeded.

---

## Quick Reference Summary

| Step | Action | Command |
| :--- | :--- | :--- |
| **1. Inspect Context & Namespaces** | Active context | `kubectx` |
| | List namespaces | `kubens` |
| | System pods | `kubectl get pods -n kube-system` |
| **2. Namespace & Workload** | Create namespace | `kubectl create ns demo-space` |
| | Deploy NGINX | `kubectl create deployment -n demo-space nginx --image nginx --replicas 2` |
| | View deployments | `kubectl get deployments -n demo-space` |
| **3. Resource Quota** | Create pod quota | `kubectl create quota pod-limit --hard=pods=2 -n demo-space` |
| | Scale deployment | `kubectl scale deployment/nginx --replicas 3 -n demo-space` |
| | Check deployment | `kubectl get deployment -n demo-space` |
| **4. Troubleshooting** | Describe ReplicaSet events | `kubectl describe rs -n demo-space` |

