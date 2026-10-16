# Chapter 3 — Core Kubernetes Objects: Services & Networking (Declarative)

This hands-on tutorial guides you through managing Kubernetes Services and networking declaratively using version-controlled YAML manifests. You will configure ClusterIP, NodePort, and LoadBalancer services, inspect Endpoints, test CoreDNS resolution, and observe how Services load balance traffic across dynamic Pod replicas.

All manifests referenced in this guide are located in this folder and ready to apply.

---

## Step 1: Deploy Backend Application Workload

Before declaring services, deploy a 3-replica NGINX workload to serve as the backend target.

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
```bash
kubectl apply -f deployment-web.yaml
```

### Verify Running Pods
Check pod status and view their assigned ephemeral IP addresses:
```bash
kubectl get pods -l app=web-app -o wide
```

---

## Step 2: ClusterIP Service (Internal Service Mesh)

ClusterIP provides a stable internal cluster IP address that load balances traffic across Pods matching its label selector.

### Manifest (`service-clusterip.yaml`)
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

### Inspect Service and Endpoints
Verify that the Service received an internal ClusterIP and matched the 3 backend Pod IPs:
```bash
kubectl get svc web-service-clusterip
kubectl describe svc web-service-clusterip
kubectl get endpoints web-service-clusterip
```

### Test Internal Traffic
Spin up a temporary container to verify network connectivity through the ClusterIP:
```bash
kubectl run test-curl --rm -it --image=curlimages/curl --restart=Never -- curl http://web-service-clusterip
```

---

## Step 3: NodePort Service (Static Port on Every Node)

A NodePort service exposes the application on a dedicated port (30000–32767) across every worker node in the cluster.

### Manifest (`service-nodeport.yaml`)
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

### Verify NodePort Allocation
Confirm port 30080 is active:
```bash
kubectl get svc web-service-nodeport
```

### Access via Node IP
Retrieve the IP address of any cluster node and send a request directly to the NodePort:
```bash
kubectl get nodes -o wide
curl http://<node-ip>:30080
```

---

## Step 4: LoadBalancer Service (Cloud Ingress Routing)

A LoadBalancer service requests an external cloud load balancer from your infrastructure provider to route public traffic into the cluster.

### Manifest (`service-loadbalancer.yaml`)
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

### Inspect External IP
Wait for the external cloud IP or hostname to provision:
```bash
kubectl get svc web-service-loadbalancer
```

Note: If running in Minikube, execute `minikube tunnel` in an external terminal window to assign an external IP to LoadBalancer services.

---

## Step 5: Service DNS Discovery

CoreDNS automatically creates DNS records for every Kubernetes Service.

### Fully Qualified Domain Name (FQDN) Format
```text
<service-name>.<namespace>.svc.cluster.local
```

### Query Service DNS Records
Run a DNS query pod to verify record resolution:
```bash
kubectl run dns-test --rm -it --image=busybox:1.28 --restart=Never -- nslookup web-service-clusterip
```

---

## Step 6: Cleanup

Delete all declared resources:
```bash
kubectl delete -f service-clusterip.yaml
kubectl delete -f service-nodeport.yaml
kubectl delete -f service-loadbalancer.yaml
kubectl delete -f deployment-web.yaml
```

---

## Quick Reference Summary

| Service Type | Scope | Target Port Configuration | Typical Manifest File |
| :--- | :--- | :--- | :--- |
| **ClusterIP** | Internal cluster only | `port: 80`, `targetPort: 80` | `service-clusterip.yaml` |
| **NodePort** | External via Node IP | `nodePort: 30080` | `service-nodeport.yaml` |
| **LoadBalancer** | External via Cloud LB | Auto-provisions Cloud IP | `service-loadbalancer.yaml` |

