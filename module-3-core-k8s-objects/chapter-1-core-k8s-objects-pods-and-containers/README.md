# Chapter 1 — Core Kubernetes Objects: Pods & Containers

A hands-on guide exploring Kubernetes Pod design patterns, including single-container workloads, multi-container sidecar architectures, recommended metadata labels, and security contexts.

All manifests referenced in this guide are available in this folder and ready to apply.

---

## Step 1: Single Container Pod

A basic Pod definition deploying a single container running NGINX.

### Manifest (`single-container-pod.yaml`)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: single-container-pod
spec:
  containers:
    - name: web-container
      image: nginx:latest
      ports:
        - containerPort: 80
```

### Apply and Verify
Deploy the Pod to your cluster:
```bash
kubectl apply -f single-container-pod.yaml
```

Check the status and IP assignment:
```bash
kubectl get pod single-container-pod -o wide
```

---

## Step 2: Multi-Container Pod (Sidecar Pattern)

Demonstrates a multi-container architecture where a main web application container and a logging sidecar container run in the same Pod, sharing the same network namespace (IP address) and an ephemeral storage volume.

### Manifest (`multi-container-pod.yaml`)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-pod
spec:
  containers:
    - name: web-container
      image: nginx:latest
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx

    - name: logger-container
      image: busybox:1.28
      args: [/bin/sh, -c, 'tail -n+1 -F /var/log/nginx/access.log']
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx

  volumes:
    - name: shared-logs
      emptyDir: {}
```

### Apply and Inspect Containers
Deploy the multi-container Pod:
```bash
kubectl apply -f multi-container-pod.yaml
```

View the ready status (displays `2/2` containers running):
```bash
kubectl get pod multi-container-pod
```

Stream logs from the sidecar logger container:
```bash
kubectl logs -f multi-container-pod -c logger-container
```

---

## Step 3: Labels and Metadata

Uses organizational metadata (name, namespace) and recommended standard `app.kubernetes.io` key-value labels for precise identification, querying, and selection.

### Manifest (`labeled-pod.yaml`)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: labeled-pod
  namespace: default
  labels:
    app.kubernetes.io/name: web-app
    app.kubernetes.io/instance: web-app-prod
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/component: frontend
spec:
  containers:
    - name: web-container
      image: nginx:latest
```

### Apply and Query by Labels
Deploy the labeled Pod:
```bash
kubectl apply -f labeled-pod.yaml
```

Query Pods using label selectors:
```bash
kubectl get pods -l app.kubernetes.io/name=web-app
kubectl get pods --show-labels
```

---

## Step 4: Configuration and Security Context

Enforces resource requests/limits (CPU and memory constraints) and security context policies (running as a non-root user with a read-only root filesystem and privilege escalation disabled).

### Manifest (`secure-configured-pod.yaml`)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-configured-pod
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
  containers:
    - name: web-container
      image: nginx:latest
      resources:
        requests:
          memory: "64Mi"
          cpu: "250m"
        limits:
          memory: "128Mi"
          cpu: "500m"
      securityContext:
        allowPrivilegeEscalation: false
        readOnlyRootFilesystem: true
```

### Apply and Review Configuration
Deploy the secure Pod:
```bash
kubectl apply -f secure-configured-pod.yaml
```

Inspect security settings and resource allocations:
```bash
kubectl describe pod secure-configured-pod
```

---

## Step 5: Resource Cleanup

Remove the practice Pods once testing is completed.

### Delete Pods via Manifests
```bash
kubectl delete -f single-container-pod.yaml
kubectl delete -f multi-container-pod.yaml
kubectl delete -f labeled-pod.yaml
kubectl delete -f secure-configured-pod.yaml
```

---

## Quick Reference Summary

| Pattern / Concept | Manifest File | Primary Command |
| :--- | :--- | :--- |
| **Single Container** | `single-container-pod.yaml` | `kubectl apply -f single-container-pod.yaml` |
| **Sidecar Multi-Container** | `multi-container-pod.yaml` | `kubectl logs multi-container-pod -c logger-container` |
| **Standard Labels** | `labeled-pod.yaml` | `kubectl get pods -l app.kubernetes.io/name=web-app` |
| **Security & Resources** | `secure-configured-pod.yaml` | `kubectl describe pod secure-configured-pod` |
| **Cleanup** | All manifests | `kubectl delete -f <filename.yaml>` |

