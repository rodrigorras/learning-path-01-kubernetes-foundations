# Chapter 2 — Using Kubeconfig & Selecting Contexts

**Content type:** Hands-on guide  
**Duration:** 10 to 15 minutes  

---

## Overview

When you interact with a Kubernetes cluster using `kubectl`, how does it know where your cluster is, which credentials to use, and what namespace to target? 

The answer is the **Kubeconfig** file. In this section, you will learn:
1. What the Kubeconfig file is and where it lives.
2. How clusters, users, and contexts work together.
3. How to inspect your configuration and switch between multiple cluster contexts.

---

## 1. What is Kubeconfig?

`kubeconfig` is a YAML file that stores configuration details for one or more Kubernetes clusters. By default, `kubectl` looks for this file at:

* **macOS / Linux:** `~/.kube/config`
* **Windows:** `%USERPROFILE%\.kube\config`

> **Tip:** You can also specify a custom config file using the `KUBECONFIG` environment variable or the `--kubeconfig` flag with `kubectl`.

---

## 2. Anatomy of a Kubeconfig File

A Kubeconfig file consists of three main building blocks:

```yaml
apiVersion: v1
kind: Config

# 1. CLUSTERS: Where is the API server and how do we verify it?
clusters:
- name: kind-kind
  cluster:
    server: https://127.0.0.1:51443
    certificate-authority-data: <CA_CERT_DATA>

# 2. USERS: Who is connecting and how do they authenticate?
users:
- name: kind-kind
  user:
    client-certificate-data: <CLIENT_CERT_DATA>
    client-key-data: <CLIENT_KEY_DATA>

# 3. CONTEXTS: The link combining a Cluster + User + default Namespace
contexts:
- name: kind-kind
  context:
    cluster: kind-kind
    user: kind-kind
    namespace: default

# The currently active context
current-context: kind-kind
```

### The Concept of a "Context"
A **Context** is simply a named shortcut linking:
* A **Cluster** (e.g., `kind-kind`, `minikube`, or `docker-desktop`)
* A **User** (your auth credentials)
* An optional default **Namespace** (e.g., `default`, `kube-system`, `development`)

$$\text{Context} = \text{Cluster} + \text{User} + \text{Namespace}$$

---

## 3. Inspecting Your Kubeconfig

### View the entire configuration
To see the full configuration (sensitive certs will be hidden by default):

```bash
kubectl config view
```

### View only the active context
If your config file has many clusters and you only want to see the details of the cluster you are currently connected to:

```bash
kubectl config view --minify
```

---

## 4. Selecting and Switching Contexts

If you installed multiple tools (e.g. Kind and Minikube, or Docker Desktop), or manage multiple cloud clusters, your `kubeconfig` will contain several contexts.

### Step 1: List all available contexts
See all clusters available on your machine:

```bash
kubectl config get-contexts
```

*Example Output:*
```text
CURRENT   NAME                 CLUSTER          AUTHINFO         NAMESPACE
*         kind-kind            kind-kind        kind-kind        default
          minikube             minikube         minikube         default
          docker-desktop       docker-desktop   docker-desktop   
```
* The asterisk (`*`) indicates your **current active context**.

### Step 2: Check your current context
To quickly display just the name of the active context:

```bash
kubectl config current-context
```

### Step 3: Switch to a different context
To change which cluster `kubectl` talks to, use `use-context`:

```bash
kubectl config use-context <CONTEXT_NAME>
```

*Example:*
```bash
# Switch to Minikube:
kubectl config use-context minikube

# Switch back to Kind:
kubectl config use-context kind-kind
```

All subsequent `kubectl` commands will now target the selected cluster!

---

## 5. Helpful Shortcut: Setting a Default Namespace

By default, `kubectl` sends commands to the `default` namespace. If you find yourself constantly typing `-n my-namespace`, you can permanently bind a default namespace to your current context:

```bash
kubectl config set-context --current --namespace=development
```

Now, running `kubectl get pods` will automatically query the `development` namespace.

To reset back to default:
```bash
kubectl config set-context --current --namespace=default
```

---

## 6. Pro-Tip: Fast Context Switching Tools

In real-world environments with dozens of clusters and namespaces, typing full `kubectl config` commands can get tedious. Developers commonly install two lightweight open-source helper tools:

* **[kubectx](https://github.com/ahmetb/kubectx):** Switch clusters with a single command (e.g. `kubectx minikube`).
* **[kubens](https://github.com/ahmetb/kubectx):** Switch namespaces with a single command (e.g. `kubens development`).

*(Install via Homebrew on macOS: `brew install kubectx`)*

