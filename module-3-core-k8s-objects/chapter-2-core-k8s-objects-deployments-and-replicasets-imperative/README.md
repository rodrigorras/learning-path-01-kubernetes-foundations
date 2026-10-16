# Chapter 2 — Core Kubernetes Objects: Deployments & ReplicaSets (Imperative)

This hands-on tutorial covers managing Kubernetes Deployments and ReplicaSets imperatively using `kubectl`. You will learn how to create deployments, scale them, test self-healing, perform image updates, annotate revisions, and execute rollbacks.

---

## Step 1: Initial Deployment & ReplicaSet Inspection

Check if any deployments exist, create a new deployment, and inspect its associated ReplicaSet.

### Check Existing Deployments
Verifies currently active deployments in your namespace:
```bash
kubectl get deployments
```

### Create Deployment with 5 Replicas
Creates a deployment named `myapp` with 5 replicas running NGINX:
```bash
kubectl create deployment myapp --image=nginx --replicas=5
```

### Verify Deployment Status
Confirms ready and available replica counts:
```bash
kubectl get deployments
```

### View Created ReplicaSet
Lists ReplicaSets (the name will be prefixed with `myapp-`):
```bash
kubectl get replicaset
```

### Describe the ReplicaSet
Verifies pod creation events and controller ownership links:
```bash
kubectl describe replicaset <replicaset-name>
```

---

## Step 2: Scaling and Self-Healing

Demonstrate scaling down, scaling up, and verifying Kubernetes self-healing when pods are deleted.

### Scale Down to 1 Replica
Scales the deployment down to a single pod:
```bash
kubectl scale deployment myapp --replicas=1
```

### Verify Pod Termination
Confirms that the ReplicaSet scaled down and deleted 4 pods:
```bash
kubectl describe replicaset <replicaset-name>
```

### Scale Back Up to 5 Replicas
Scales the deployment back up to 5 running pods:
```bash
kubectl scale deployment myapp --replicas=5
```

### Simulate Pod Failure
Delete 3 pods manually to simulate node or process failures (replace with actual pod names):
```bash
kubectl delete pod <pod-1> <pod-2> <pod-3>
```

### Confirm Self-Healing
Verify that the Deployment controller immediately detected the difference and recreated missing pods back to 5:
```bash
kubectl get deployment myapp
```

### Inspect ReplicaSet Healing Events
Confirms pod recreation events in the ReplicaSet logs:
```bash
kubectl describe replicaset <replicaset-name>
```

---

## Step 3: Rolling Updates and Revision History

Re-create a deployment, annotate revisions, update container image versions, and inspect deployment history.

### Reset Workload
Clean up existing deployment (optional):
```bash
kubectl delete deployment myapp
```

### Create Deployment with Initial Version
Deploys 2 replicas running `nginx:1.28.3`:
```bash
kubectl create deployment myapp --image=nginx:1.28.3 --replicas=2
```

### Annotate Revision 1
Attaches a change-cause annotation for history tracking:
```bash
kubectl annotate deployment myapp kubernetes.io/change-cause="Initial version 1.28.3"
```

### View Rollout History
Inspects recorded revisions:
```bash
kubectl rollout history deployment myapp
```

### Update Image to Version 1.30.4
Updates the container image imperatively:
```bash
kubectl set image deployment/myapp nginx=nginx:1.30.4
```

### Annotate Revision 2
Records the update description:
```bash
kubectl annotate deployment myapp kubernetes.io/change-cause="Upgrade image to 1.30.4" --overwrite
```

### Verify Updated History
Confirms revision 2 is recorded:
```bash
kubectl rollout history deployment myapp
```

### Bump Image to Latest (1.31.3)
Performs another rolling update to version 1.31.3:
```bash
kubectl set image deployment/myapp nginx=nginx:1.31.3
```

### Annotate Revision 3
Records the latest update description:
```bash
kubectl annotate deployment myapp kubernetes.io/change-cause="Bump version to latest 1.31.3" --overwrite
```

### View Rollout History and Status
Streams rollout completion and reviews all 3 revisions:
```bash
kubectl rollout history deployment myapp
kubectl rollout status deployment myapp
```

---

## Step 4: Rollbacks

Roll back the deployment directly to a specific historical revision.

### Roll Back to Revision 1
Reverts the deployment back to the initial revision:
```bash
kubectl rollout undo deployment myapp --to-revision=1
```

### Check Deployment Status
Verifies deployment availability post-rollback:
```bash
kubectl get deployments
```

### List Current ReplicaSets
Observes active and inactive ReplicaSets:
```bash
kubectl get replicaset
```

### Verify Rolled Back Pods
Inspects the active ReplicaSet to confirm pods are running the revision 1 image (`nginx:1.28.3`):
```bash
kubectl describe replicaset <first-revision-replicaset-name>
```

---

## Step 5: Resource Cleanup

Clean up all practice resources:
```bash
kubectl delete deployment myapp
```

---

## Quick Reference Summary

| Phase | Imperative Command | Purpose |
| :--- | :--- | :--- |
| **Create** | `kubectl create deployment myapp --image=nginx --replicas=5` | Deploy workload imperatively |
| **Inspect ReplicaSets** | `kubectl get replicaset` | List active ReplicaSets |
| **Scale** | `kubectl scale deployment myapp --replicas=<n>` | Adjust replica count |
| **Simulate Failure** | `kubectl delete pod <pod-name>` | Test self-healing reconciliation |
| **Annotate Revision** | `kubectl annotate deployment <name> kubernetes.io/change-cause="<msg>"` | Record rollout history message |
| **Update Image** | `kubectl set image deployment/<name> <cname>=<image>` | Trigger rolling update |
| **Rollout History** | `kubectl rollout history deployment/<name>` | View revision history |
| **Rollout Status** | `kubectl rollout status deployment/<name>` | Stream update progress |
| **Rollback Revision** | `kubectl rollout undo deployment/<name> --to-revision=<n>` | Revert to specific revision |
| **Cleanup** | `kubectl delete deployment myapp` | Tear down deployment & pods |
