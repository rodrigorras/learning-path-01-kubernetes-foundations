# Chapter 3 — Core Kubernetes Objects: Services & Networking

This hands-on tutorial covers Kubernetes Services and networking fundamentals. You will learn how Services provide stable IP addresses, load balance traffic across Pod replicas, match workloads using label selectors, manage Endpoints, and configure ClusterIP, NodePort, and LoadBalancer service types.

All manifests referenced in this guide are available in this folder and ready to apply.

---

## Step 1: Deploy Backend Application Workload

Before exposing services, create a multi-replica NGINX deployment to act as the backend service target.

### Manifest (`deployment-web.yaml`)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
        - name: nginx
          image: nginx:alpine
          ports:
            - containerPort: 80
```

### Apply Deployment
Deploy the backend workload:
```bash
kubectl apply -f deployment-web.yaml
```

### Verify Running Pods
Verify all 3 replicas are running and observe their individual IP addresses:
```bash
kubectl get pods -l app=web-app -o wide
```

---

## Step 2: ClusterIP Service (Internal Communication)

ClusterIP is the default Kubernetes Service type. It exposes the service on an internal IP address reachable only from within the cluster.

### Declarative Manifest (`service-clusterip.yaml`)
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service-clusterip
  labels:
    app: web-app
spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

### Apply Manifest
```bash
kubectl apply -f service-clusterip.yaml
```

### Imperative Alternative
You can also generate and expose a ClusterIP service imperatively using `kubectl`:
```bash
kubectl expose deployment web-app --name=web-service-clusterip-cmd --port=80 --target-port=80
```

### Inspect Service and Endpoints
Inspect the virtual cluster IP and verify that Kubernetes automatically mapped the 3 backend Pod IPs as endpoints:
```bash
kubectl get svc web-service-clusterip
kubectl describe svc web-service-clusterip
kubectl get endpoints web-service-clusterip
```

### Test Internal Connectivity
Run a temporary diagnostic Pod to verify DNS resolution and HTTP traffic to the ClusterIP service:
```bash
kubectl run test-curl --rm -it --image=curlimages/curl -- restart=Never -- curl http://web-service-clusterip
```

---

## Step 3: NodePort Service (Node-Level External Access)

A NodePort service opens a specific port across all cluster nodes (within the default range 30000–32767), forwarding incoming node traffic to the underlying Service and target Pods.

### Declarative Manifest (`service-nodeport.yaml`)
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service-nodeport
  labels:
    app: web-app
spec:
  type: NodePort
  selector:
    app: web-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30080
```

### Apply Manifest
```bash
kubectl apply -f service-nodeport.yaml
```

### Imperative Alternative
Expose a NodePort service imperatively:
```bash
kubectl expose deployment web-app --name=web-service-nodeport-cmd --type=NodePort --port=80
```

### Inspect NodePort Service
Confirm the allocated NodePort:
```bash
kubectl get svc web-service-nodeport
```

### Access via Node IP
Retrieve a node IP and test connectivity through the static NodePort:
```bash
kubectl get nodes -o wide
curl http://<node-ip>:30080
```

---

## Step 4: LoadBalancer Service (Cloud & External Ingress)

A LoadBalancer service integrates with cloud provider load balancers (AWS ELB, GCP Cloud Load Balancing, Azure Load Balancer, or local controllers like MetalLB / Minikube tunnel) to provision an external IP address for outside traffic.

### Declarative Manifest (`service-loadbalancer.yaml`)
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service-loadbalancer
  labels:
    app: web-app
spec:
  type: LoadBalancer
  selector:
    app: web-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

### Apply Manifest
```bash
kubectl apply -f service-loadbalancer.yaml
```

### Imperative Alternative
Expose a LoadBalancer service imperatively:
```bash
kubectl expose deployment web-app --name=web-service-lb-cmd --type=LoadBalancer --port=80
```

### Inspect LoadBalancer Status
Check the external IP assignment:
```bash
kubectl get svc web-service-loadbalancer
```

Note: In local Minikube clusters, run `minikube tunnel` in a separate terminal to route external IP traffic to the LoadBalancer service.

---

## Step 5: Kubernetes DNS and CoreDNS Resolution

Every Service created in Kubernetes receives a predictable DNS entry managed by CoreDNS.

### Standard DNS Name Formats
Within the same namespace:
```text
<service-name>
```

Across different namespaces:
```text
<service-name>.<namespace-name>.svc.cluster.local
```

### Test DNS Name Resolution
Run an interactive container to query the CoreDNS service records:
```bash
kubectl run dns-test --rm -it --image=busybox:1.28 --restart=Never -- nslookup web-service-clusterip
```

---

## Step 6: Cleanup

Delete the deployment and services created during this tutorial:
```bash
kubectl delete -f service-clusterip.yaml
kubectl delete -f service-nodeport.yaml
kubectl delete -f service-loadbalancer.yaml
kubectl delete -f deployment-web.yaml
```

---

## Quick Reference Summary

| Service Type | Scope | Default Port Range | Primary Use Case |
| :--- | :--- | :--- | :--- |
| **ClusterIP** | Internal to cluster | Standard ports (e.g. 80, 443) | Microservice-to-microservice internal communication |
| **NodePort** | External via Node IP | 30000–32767 | Direct node port access for development or edge gateways |
| **LoadBalancer** | External via Cloud LB | Standard ports (e.g. 80, 443) | Public-facing production applications and cloud ingress |
| **ExternalName** | Internal alias | N/A | Maps a Kubernetes service to an external DNS CNAME |
