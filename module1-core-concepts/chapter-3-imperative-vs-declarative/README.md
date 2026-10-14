# Chapter 3 — Imperative vs. Desired State, YAML Manifests & The Reconciliation Loop

**Content type:** Hands-on demonstration  
**Duration:** 10 to 15 minutes  

---

## 1. Imperative vs. Desired State (Declarative)

* **Imperative (How):** You run step-by-step CLI commands (`kubectl run`, `kubectl create`). Good for quick tests or one-off debugging, but changes are not tracked in Git.
* **Declarative / Desired State (What):** You define the target state in a YAML file and apply it (`kubectl apply -f file.yaml`). Kubernetes continuously works to keep the cluster matching your file.

| Concept | Imperative | Declarative (Desired State) |
| :--- | :--- | :--- |
| **Action** | Run commands directly (`kubectl run`) | Apply configuration files (`kubectl apply -f`) |
| **Tracking** | Not tracked, easily forgotten | Version-controlled in Git (GitOps) |
| **Recovery** | Manual intervention if lost | Automatic self-healing |

---

## 2. Anatomy of a YAML Manifest

Every Kubernetes manifest has four essential fields:

```yaml
apiVersion: v1            # 1. API version for the resource
kind: Pod                 # 2. Type of resource
metadata:                 # 3. Identification (name, labels)
  name: declarative-nginx-pod
  labels:
    app: demo-web
spec:                     # 4. Desired state specification
  containers:
  - name: nginx-container
    image: nginx:alpine
    ports:
    - containerPort: 80
```

* **`apiVersion`**: Which version of the Kubernetes API to use.
* **`kind`**: What type of object you are creating (`Pod`, `Deployment`, `Service`).
* **`metadata`**: Identifying data like `name` and `labels`.
* **`spec`**: The desired state (containers, ports, volumes, replicas).

---

## 3. Demo 1: Declarative Pod Deployment

Make sure your cluster is running.

### 1. Deploy the Pod
Apply the provided [`pod.yaml`](pod.yaml):

```bash
kubectl apply -f pod.yaml
```

### 2. Verify the Pod
Check that the pod is running:

```bash
kubectl get pods -l app=demo-web
```

### 3. Inspect Live State
Notice how Kubernetes stores your desired `spec` and attaches a runtime `status`:

```bash
kubectl get pod declarative-nginx-pod -o yaml
```

> **Compare with imperative:** Instead of writing YAML, you could run `kubectl run nginx-test --image=nginx:alpine`. While faster for a one-off test, it doesn't give you a file to commit to Git or share with your team.

---

## 4. Demo 2: The Reconciliation Loop in Action

The **Reconciliation Loop** is the control loop inside Kubernetes that constantly checks:
1. **Current State:** What is actually running in the cluster?
2. **Desired State:** What did you ask for in your YAML file?
3. **Action:** If they don't match, Kubernetes fixes it automatically.

> **Note:** A standalone Pod has no controller managing it. If you delete a bare Pod, it will not come back. To see automatic self-healing, we use a **Deployment**.

### 1. Deploy the Deployment (Desired State = 2 Replicas)
Apply [`deployment.yaml`](deployment.yaml):

```bash
kubectl apply -f deployment.yaml
```

Verify that 2 pods are running:

```bash
kubectl get pods -l app=reconciliation-demo
```

### 2. Simulate a Pod Failure
Delete one of the running pods:

```bash
kubectl delete pod <POD_NAME>
```

*(Replace `<POD_NAME>` with one of the pod names from the previous command)*

### 3. Watch It Self-Heal
Immediately list the pods again:

```bash
kubectl get pods -l app=reconciliation-demo
```

**What happened?**  
The moment the pod was deleted, the controller noticed that `current replicas (1) != desired replicas (2)`. The reconciliation loop immediately launched a new pod to restore your desired state.

### 4. Declarative Scaling
To scale up, update [`deployment.yaml`](deployment.yaml):
1. Change `replicas: 2` to `replicas: 3`.
2. Apply the change:

```bash
kubectl apply -f deployment.yaml
```

Kubernetes detects the difference and reconciles the state by adding a third pod:

```bash
kubectl get pods -l app=reconciliation-demo
```

---

## 5. Clean Up

Remove the demo resources:

```bash
kubectl delete -f pod.yaml
kubectl delete -f deployment.yaml
```
