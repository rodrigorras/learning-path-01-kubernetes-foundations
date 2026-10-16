# Chapter 2 — Core Kubernetes Objects: Deployments & ReplicaSets (Declarative)

A hands-on guide exploring Kubernetes Deployments, ReplicaSet lifecycles, rolling updates, scaling, and declarative rollbacks.

All manifests referenced in this guide are located in this folder and ready to apply.

---

## Step 1: Initial Deployment Configuration

Create and apply the base deployment manifest `deployment-myapp.yaml` configured with 2 replicas running `nginx:1.28.3`.

### Manifest (`deployment-myapp.yaml`)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: nginx
        image: nginx:1.28.3
```

### Apply Initial Deployment
Deploy the workload to the cluster:
```bash
kubectl apply -f deployment-myapp.yaml
```

### Verify Initial Deployment
Check running pods and inspect pod image details:
```bash
kubectl get pods
kubectl describe pod <pod-name>
```

---

## Step 2: Upgrade Deployment (Rolling Update Step 1)

Upgrade the NGINX image version to `1.30.4` and add a `kubernetes.io/change-cause` annotation to track the revision in rollout history.

### Updated Manifest (`deployment-myapp.yaml`)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  annotations:
    kubernetes.io/change-cause: "bump deployment of nginx"
  labels:
    app: myapp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: nginx
        image: nginx:1.30.4
```

### Apply Upgrade
Apply the updated manifest to trigger a rolling update:
```bash
kubectl apply -f deployment-myapp.yaml
```

### Verify Upgrade and ReplicaSets
Observe that a new ReplicaSet was created while the old ReplicaSet was scaled down to 0:
```bash
kubectl get rs
kubectl describe pod <pod-name>
```

---

## Step 3: Upgrade to Latest and Scale Replicas (Rolling Update Step 2)

Bump the image version to `1.31.3` (or latest), scale the replica count from 2 to 3, and update the change-cause annotation.

### Updated Manifest (`deployment-myapp.yaml`)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  annotations:
    kubernetes.io/change-cause: "bump deployments of nginx to latest version"
  labels:
    app: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: nginx
        image: nginx:1.31.3
```

### Apply Upgrade and Watch Rolling Update
Apply the manifest and stream the rolling update across ReplicaSets in real time:
```bash
kubectl apply -f deployment-myapp.yaml
kubectl get rs -w
```

---

## Step 4: Roll Back Deployment Declaratively

Roll back to the initial stable image version (`1.28.3`) while keeping 3 replicas by updating the manifest declaratively.

### Updated Manifest (`deployment-myapp.yaml`)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  annotations:
    kubernetes.io/change-cause: "roll back deployment to 1.28.3"
  labels:
    app: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: nginx
        image: nginx:1.28.3
```

### Apply Rollback
Apply the rollback manifest and watch the ReplicaSets adjust:
```bash
kubectl apply -f deployment-myapp.yaml
kubectl get rs -w
```

---

## Step 5: Rollout Inspection & History

Use built-in rollout subcommands to inspect revision history and rollout progress.

### Check Rollout Status
Confirms whether all replicas have successfully updated:
```bash
kubectl rollout status deployment/myapp-deployment
```

### View Revision History
Displays revision history populated by the `kubernetes.io/change-cause` annotations:
```bash
kubectl rollout history deployment/myapp-deployment
```

---

## Step 6: Resource Cleanup

Tear down the deployment and all associated ReplicaSets and Pods once practice is complete:
```bash
kubectl delete -f deployment-myapp.yaml
```

---

## Quick Reference Summary

| Phase / Action | Command | Purpose |
| :--- | :--- | :--- |
| **Apply deployment** | `kubectl apply -f deployment-myapp.yaml` | Create or update deployment declaratively |
| **Inspect pods** | `kubectl get pods` | View running replicas |
| **Inspect ReplicaSets** | `kubectl get rs` | Observe active and historical ReplicaSets |
| **Watch rolling update** | `kubectl get rs -w` | Stream live scale-up / scale-down events |
| **Rollout status** | `kubectl rollout status deployment/<name>` | Check update completion |
| **Rollout history** | `kubectl rollout history deployment/<name>` | View tracked revisions & change causes |
| **Delete deployment** | `kubectl delete -f deployment-myapp.yaml` | Clean up all deployment resources |

