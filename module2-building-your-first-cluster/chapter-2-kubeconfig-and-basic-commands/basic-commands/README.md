# Basic Kubectl Commands Reference Guide

A structured, step-by-step guide to working with Kubernetes clusters, managing workloads, inspecting state, troubleshooting, and cleaning up resources based on the hands-on video tutorial.

---

## Step 1: Cluster & Context Verification

Use these commands to verify which cluster you are connected to and ensure the node control plane is ready.

### View Available Contexts
Displays available context configurations to show which Kubernetes cluster you are currently targeting:
```bash
kubectl config get-contexts
```

### Switch Contexts Easily (`kubectx`)
An alternative utility used to easily switch between cluster contexts:
```bash
kubectx
```

### Cluster Control Plane Info
Provides information about the control plane, including the Kubernetes API server address and core services like CoreDNS:
```bash
kubectl cluster-info
```

### List Cluster Nodes
Lists all cluster nodes along with their status, IP, kernel, and container runtime version:
```bash
kubectl get nodes
```

---

## Step 2: Creating and Managing Resources

Learn how to manage namespaces and deploy pods using both imperative (direct commands) and declarative (YAML configuration files) approaches.

### Imperative Management

#### Create a Namespace
Creates a new isolated namespace:
```bash
kubectl create namespace <namespace-name>
```
**Video Execution:** `kubectl create namespace nginx`

#### Run a Pod Directly
Directly creates and runs a pod imperatively without needing a manifest file:
```bash
kubectl run <pod-name> --image=<image-name> -n <namespace>
```
**Video Execution:** Attempted `kubectl run nginx --image=nginx -n nginx` *(failed initially because the namespace had not been created yet)*.

### Declarative Management

#### Apply a Manifest File
Applies a declarative YAML configuration file to create or update cluster objects (e.g., pods, deployments, services):
```bash
kubectl apply -f <filename.yaml>
```
**Video Execution:** Applied as `kubectl apply -f pod.yaml` (deploying the `nginx-declarative` pod into namespace `nginx`).

---

## Step 3: Observation and Status Inspection

Use observation commands to check object health and inspect detailed operational configurations.

### List API Resources
Lists all available API resources/objects configured within the cluster:
```bash
kubectl api-resources
```

### List Namespaced Resources
Filters and lists only the objects that exist within specific namespaces (e.g., pods, deployments, roles):
```bash
kubectl api-resources --namespaced=true
```

### List Pods Across All Namespaces
Lists all pods across all namespaces within the cluster:
```bash
kubectl get pods -A
```

### List Pods with Extended Details
Retrieves detailed pod information including assigned IP addresses and node allocations:
```bash
kubectl get pods -n <namespace> -o wide
```
**Video Execution:** Ran with flag ordering:
```bash
kubectl get pods -o wide -n nginx
```

### Export Pod YAML Specification
Outputs the full live declarative YAML status of a specific pod:
```bash
kubectl get pod <pod-name> -n <namespace> -o yaml
```
**Video Execution:** Executed specifically for the declarative pod as:
```bash
kubectl get pod nginx-declarative -n nginx -o yaml
```

### Export Node YAML Specification
Displays full YAML output for nodes, including resource metrics like CPU, memory, and pod capacity:
```bash
kubectl get nodes -o yaml
```

---

## Step 4: Troubleshooting and Debugging

When pods fail (e.g., due to an image pull error or code crash), use these commands to locate and resolve issues.

### Describe Pod Details & Lifecycle Events
Shows detailed metadata and lifecycle events for a pod to reveal why it failed (e.g., `ImagePullBackOff`):
```bash
kubectl describe pod <pod-name> -n <namespace>
```
**Video Execution:** Executed with flags ordered as:
```bash
kubectl describe pod -n nginx nginx-declarative
```

### Stream Pod Logs
Streams live application logs running inside the specified container:
```bash
kubectl logs -f <pod-name> -n <namespace>
```
**Video Execution:** Executed as:
```bash
kubectl logs -f -n nginx nginx-declarative
```

### Interactive Terminal Inside Pod
Opens an interactive bash terminal inside a running pod container for direct troubleshooting:
```bash
kubectl exec -it <pod-name> -n <namespace> -- bash
```
**Video Execution:** Executed as:
```bash
kubectl exec -it -n nginx nginx-declarative -- bash
```

---

## Step 5: Testing and Performance Monitoring

Test container functionality locally and track real-time resource utilization across nodes and pods.

### Port-Forwarding to Local Machine
Establishes a network tunnel between your local machine and a running pod to test services locally:
```bash
kubectl port-forward <pod-name> <local-port>:<container-port> -n <namespace>
```

### Node Resource Metrics
Displays active CPU and memory consumption for every node in the cluster:
```bash
kubectl top nodes
```

### Pod Resource Metrics
Displays real-time CPU and memory usage metrics for individual pods:
```bash
kubectl top pods
```

---

## Step 6: Resource Cleanup

Tear down resources once testing is completed.

### Delete an Individual Pod
Deletes an individual pod:
```bash
kubectl delete pod <pod-name> -n <namespace>
```

### Delete a Namespace
Deletes the namespace along with all objects created inside it:
```bash
kubectl delete namespace <namespace-name>
```
**Video Execution:** Executed as `kubectl delete namespace nginx`.

---

## Quick Reference Summary

| Step | Action | Canonical Command | Video Example |
| :--- | :--- | :--- | :--- |
| **1. Cluster Verification** | Get contexts | `kubectl config get-contexts` | `kubectl config get-contexts` |
| | Switch context | `kubectx` | `kubectx` |
| | Control plane info | `kubectl cluster-info` | `kubectl cluster-info` |
| | List nodes | `kubectl get nodes` | `kubectl get nodes` |
| **2. Resource Management** | Create namespace | `kubectl create namespace <name>` | `kubectl create namespace nginx` |
| | Imperative pod | `kubectl run <name> --image=<img> -n <ns>` | `kubectl run nginx --image=nginx -n nginx` |
| | Declarative apply | `kubectl apply -f <file.yaml>` | `kubectl apply -f pod.yaml` |
| **3. Observation** | All API resources | `kubectl api-resources` | `kubectl api-resources` |
| | Namespaced resources | `kubectl api-resources --namespaced=true` | `kubectl api-resources --namespaced=true` |
| | Pods in all namespaces | `kubectl get pods -A` | `kubectl get pods -A` |
| | Extended pod info | `kubectl get pods -n <ns> -o wide` | `kubectl get pods -o wide -n nginx` |
| | Pod live YAML | `kubectl get pod <name> -n <ns> -o yaml` | `kubectl get pod nginx-declarative -n nginx -o yaml` |
| | Node live YAML | `kubectl get nodes -o yaml` | `kubectl get nodes -o yaml` |
| **4. Troubleshooting** | Describe pod & events | `kubectl describe pod <name> -n <ns>` | `kubectl describe pod -n nginx nginx-declarative` |
| | Follow pod logs | `kubectl logs -f <name> -n <ns>` | `kubectl logs -f -n nginx nginx-declarative` |
| | Interactive shell | `kubectl exec -it <name> -n <ns> -- bash` | `kubectl exec -it -n nginx nginx-declarative -- bash` |
| **5. Testing & Monitoring**| Port forward | `kubectl port-forward <name> <lport>:<cport> -n <ns>` | `kubectl port-forward ...` |
| | Node metrics | `kubectl top nodes` | `kubectl top nodes` |
| | Pod metrics | `kubectl top pods` | `kubectl top pods` |
| **6. Cleanup** | Delete pod | `kubectl delete pod <name> -n <ns>` | Verbally mentioned (`delete pod nginx`) |
| | Delete namespace | `kubectl delete namespace <name>` | `kubectl delete namespace nginx` |
