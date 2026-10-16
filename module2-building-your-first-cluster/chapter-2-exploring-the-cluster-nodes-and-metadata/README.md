# Chapter 2 — Exploring the Cluster: Nodes & Metadata

A practical guide to inspecting cluster health, examining node metadata and capacity, testing pod scheduling behavior, and managing node taints.

---

## Step 1: Inspecting Cluster Health and Nodes

Verify that the Kubernetes control plane components and API health checks are functioning properly.

### Check Cluster Endpoint and Service Info
Provides information about the control plane and core services:
```bash
kubectl cluster-info
```

### Verify API Readiness
Queries the raw API endpoint to verify overall cluster readiness:
```bash
kubectl get --raw /readyz
```

### List Cluster Nodes with Extended Details
Lists all cluster nodes with IP addresses, OS, kernel versions, and container runtimes:
```bash
kubectl get nodes -o wide
```

---

## Step 2: Examining Node Metadata and Capacity

Use `describe` to review detailed node attributes such as labels, annotations, taints, system resources (CPU, RAM, ephemeral storage), and pod limits.

### Inspect Node Details
Displays full metadata, allocated resources, and scheduling status for a node:
```bash
kubectl describe node <control-plane-node-name>
```

### Key Areas to Observe in Output

**Labels**  
Used by Kubernetes for pod scheduling, node selectors, affinity rules, and service endpoints.

**Annotations**  
Non-identifying metadata used by external tools, operators, monitoring systems, and CNI plugins.

**Taints**  
By default, control plane nodes carry a `NoSchedule` taint to prevent general workloads from being scheduled on them.

**Capacity & Allocatable**  
Shows total physical versus allocatable CPU, memory, storage, and maximum allowed pods (typically 110 pods per node).

---

## Step 3: Testing Pod Scheduling with Node Taints

Observe how node taints dictate workload placement, and how removing a taint allows workloads to schedule onto the control plane.

### Step A: Deploy Workloads to Default Cluster Setup
Deploy a sample NGINX deployment with 10 replicas:
```bash
kubectl create deployment nginx --image=nginx --replicas=10
```

Verify that all pods are scheduled exclusively on worker nodes due to the control plane's default `NoSchedule` taint:
```bash
kubectl get pods -o wide
```

### Step B: Remove the Control Plane Taint
To allow regular pods to be scheduled on the control plane node, remove the `NoSchedule` taint (note the trailing minus `-` sign):
```bash
kubectl taint nodes <control-plane-node-name> node-role.kubernetes.io/control-plane:NoSchedule-
```

### Step C: Verify Control Plane Scheduling
Re-create the deployment to observe the updated scheduling distribution:
```bash
# Delete existing deployment
kubectl delete deployment nginx

# Re-create deployment with 10 replicas
kubectl create deployment nginx --image=nginx --replicas=10

# Check pod placement across all nodes
kubectl get pods -o wide
```
Pods will now be distributed across both worker nodes and the control plane node.

---

## Quick Reference Summary

| Step | Action | Command |
| :--- | :--- | :--- |
| **1. Health & Discovery** | Cluster info | `kubectl cluster-info` |
| | API readiness probe | `kubectl get --raw /readyz` |
| | Extended node details | `kubectl get nodes -o wide` |
| **2. Metadata & Capacity** | Inspect node details | `kubectl describe node <node-name>` |
| **3. Workload Placement** | Deploy 10 replicas | `kubectl create deployment nginx --image=nginx --replicas=10` |
| | Verify pod nodes | `kubectl get pods -o wide` |
| | Remove control plane taint | `kubectl taint nodes <node-name> node-role.kubernetes.io/control-plane:NoSchedule-` |
| | Delete deployment | `kubectl delete deployment nginx` |
