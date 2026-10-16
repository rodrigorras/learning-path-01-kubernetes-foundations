# Chapter 3 — Core Kubernetes Objects: Services & Networking (Imperative)

This hands-on tutorial covers managing Kubernetes Services and networking imperatively using the `kubectl` CLI. You will learn how to expose deployments on the fly, create ClusterIP, NodePort, and LoadBalancer services, inspect endpoints, configure port forwarding, and test network connectivity without writing YAML files.

---

## Step 1: Deploy Application Workload Imperatively

Create a 3-replica NGINX deployment and open container port 80.

### Create Deployment
```bash
kubectl create deployment web-app --image=nginx:alpine --replicas=3 --port=80
```

### Verify Deployment and Pods
Confirm the deployment is ready and inspect the assigned pod IPs:
```bash
kubectl get deployment web-app
kubectl get pods -l app=web-app -o wide
```

---

## Step 2: Expose ClusterIP Service Imperatively

Expose the deployment internally within the cluster.

### Expose with `kubectl expose`
Creates a ClusterIP service that targets container port 80 and maps to service port 80:
```bash
kubectl expose deployment web-app --name=web-service-clusterip --port=80 --target-port=80
```

### Alternative: `kubectl create service clusterip`
You can also create a standalone ClusterIP service directly with specified port mappings:
```bash
kubectl create service clusterip web-service-direct --tcp=80:80
```

### Inspect Service and Endpoints
View the cluster IP and verify that the backend pod IPs were automatically registered as endpoints:
```bash
kubectl get svc web-service-clusterip
kubectl describe svc web-service-clusterip
kubectl get endpoints web-service-clusterip
```

### Test Connectivity from Inside Cluster
Spin up an ephemeral pod to test DNS and HTTP communication:
```bash
kubectl run test-curl --rm -it --image=curlimages/curl --restart=Never -- curl http://web-service-clusterip
```

---

## Step 3: Expose NodePort Service Imperatively

Open an external port across all cluster nodes to route traffic to the workload.

### Expose with `kubectl expose`
```bash
kubectl expose deployment web-app --name=web-service-nodeport --type=NodePort --port=80
```

### Inspect Allocated NodePort
Identify the dynamically allocated node port in the range 30000–32767:
```bash
kubectl get svc web-service-nodeport
```

### Test External Access via NodePort
Get the IP address of any cluster node and send an HTTP request:
```bash
kubectl get nodes -o wide
curl http://<node-ip>:<allocated-nodeport>
```

If using Minikube, open the service URL directly:
```bash
minikube service web-service-nodeport --url
```

---

## Step 4: Expose LoadBalancer Service Imperatively

Provision a cloud load balancer with an external IP address.

### Expose with `kubectl expose`
```bash
kubectl expose deployment web-app --name=web-service-lb --type=LoadBalancer --port=80
```

### Check External IP Provisioning
Monitor the service until the external IP or hostname is assigned:
```bash
kubectl get svc web-service-lb -w
```

Note: On local Minikube installations, run `minikube tunnel` in a separate terminal to route external traffic to LoadBalancer services.

---

## Step 5: Port Forwarding for Local Debugging

Directly forward a local workstation port to an internal Kubernetes service without exposing it externally.

### Forward Local Port 8080 to Service Port 80
```bash
kubectl port-forward svc/web-service-clusterip 8080:80
```

### Test Local Forwarding
In another terminal, test HTTP access directly on localhost:
```bash
curl http://localhost:8080
```

---

## Step 6: Cleanup

Delete all imperatively created services and deployments:
```bash
kubectl delete svc web-service-clusterip web-service-nodeport web-service-lb
kubectl delete deployment web-app
```

---

## Quick Reference Summary

| Task | Imperative Command |
| :--- | :--- |
| **Expose Deployment (ClusterIP)** | `kubectl expose deployment web-app --name=web-svc --port=80 --target-port=80` |
| **Create ClusterIP Service Directly** | `kubectl create service clusterip web-svc --tcp=80:80` |
| **Expose Deployment (NodePort)** | `kubectl expose deployment web-app --name=web-np --type=NodePort --port=80` |
| **Create NodePort Service Directly** | `kubectl create service nodeport web-np --tcp=80:80 --node-port=30080` |
| **Expose Deployment (LoadBalancer)** | `kubectl expose deployment web-app --name=web-lb --type=LoadBalancer --port=80` |
| **View Service Endpoints** | `kubectl get endpoints <service-name>` |
| **Port Forward to Localhost** | `kubectl port-forward svc/<service-name> 8080:80` |
| **Open Service in Browser (Minikube)**| `minikube service <service-name>` |

