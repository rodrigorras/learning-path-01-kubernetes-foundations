# Chapter 4 — Core Kubernetes Objects: ConfigMaps & Secrets (Imperative vs. Declarative)

In this lab, you will practice managing Kubernetes configuration data using both imperative CLI commands and declarative YAML manifests:

ConfigMap: Created imperatively, consumed declaratively.

Secret: Created declaratively, consumed declaratively.

---

## Exercise 1: ConfigMaps (Imperative Creation + Declarative Consumption)

### Step 1.1: Create the ConfigMap (Imperative)
Create the ConfigMap directly from the command line using literal values and a configuration file:

```bash
kubectl create configmap app-config \
  --from-literal=APP_COLOR=blue \
  --from-file=nginx.conf
```

Inspect the created ConfigMap:

```bash
kubectl get configmap app-config
kubectl describe configmap app-config
```

### Step 1.2: Deploy the Pod (Declarative)
Create `cm-pod.yaml` to inject the environment variable and mount the configuration file:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: cm-pod
spec:
  containers:
  - name: myapp
    image: nginx
    env:
    - name: CONTAINER_COLOR
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: APP_COLOR
    volumeMounts:
    - name: config-volume
      mountPath: /etc/nginx/conf.d
  volumes:
  - name: config-volume
    configMap:
      name: app-config
```

Apply the pod manifest:

```bash
kubectl apply -f cm-pod.yaml
```

### Step 1.3: Verify Environment Variable and Mount
Exec into the pod to confirm the ConfigMap values:

```bash
kubectl exec -it cm-pod -- sh
```

Inside the container, check the environment variable and mounted file:

```bash
# Verify environment variable
env | grep CONTAINER_COLOR

# Verify mounted configuration file
cat /etc/nginx/conf.d/default.conf

# Exit container
exit
```

---

## Exercise 2: Secrets (Declarative Creation + Declarative Consumption)

### Step 2.1: Create the Secret (Declarative)
Create `secret.yaml` containing the sensitive data:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
stringData:
  API_KEY: "my-secret-api-key"
  db-password: "super-secret-password"
```

Apply the secret manifest:

```bash
kubectl apply -f secret.yaml
```

### Step 2.2: Deploy the Pod (Declarative)
Create `secret-pod.yaml` to mount the secret volume and environment variable:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-pod
spec:
  containers:
  - name: myapp
    image: nginx
    env:
    - name: CONTAINER_API_KEY
      valueFrom:
        secretKeyRef:
          name: app-secret
          key: API_KEY
    volumeMounts:
    - name: secret-volume
      mountPath: /etc/secrets
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: app-secret
```

Apply the pod manifest:

```bash
kubectl apply -f secret-pod.yaml
```

### Step 2.3: Verify Secrets
Exec into the pod to inspect environment variables and volume mounts:

```bash
kubectl exec -it secret-pod -- sh
```

Inside the container, check the mounted secrets and temporary memory mount (`tmpfs`):

```bash
# Check secret environment variable
env | grep CONTAINER_API_KEY

# Check tmpfs memory mount location for secrets
df -h

# Inspect secret file content
cat /etc/secrets/db-password

# Exit container
exit
```

---

## Step 3: Cleanup

Remove the pods, ConfigMap, and Secret created during this exercise:

```bash
kubectl delete pod cm-pod secret-pod
kubectl delete configmap app-config
kubectl delete secret app-secret
```

---

## Quick Reference Summary

| Resource | Creation Method | Consumption Method | Key CLI Command / Manifest Key |
| :--- | :--- | :--- | :--- |
| **ConfigMap (Literal)** | Imperative | Declarative (env) | `kubectl create configmap <name> --from-literal=KEY=VAL` |
| **ConfigMap (File)** | Imperative | Declarative (volume) | `kubectl create configmap <name> --from-file=<filename>` |
| **Secret (stringData)** | Declarative | Declarative (env) | `secretKeyRef` in Pod `env` |
| **Secret (Volume Mount)**| Declarative | Declarative (volume) | Mounted as `tmpfs` under `/etc/secrets` |

