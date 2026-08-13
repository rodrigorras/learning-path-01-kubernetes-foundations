

<img width="866" height="471" alt="image" src="https://github.com/user-attachments/assets/b5ad1ec7-87bf-447e-b6b3-bbd265319878" />


# Chapter 5 — Exercise: Deploy Your First API

**Content type:** Hands-on exercise  
**Duration:** 10 to 15 minutes  

## Overview
In this exercise, you will connect the core concepts of Pods, Deployments, Services, ConfigMaps, and Secrets. Rather than building a custom Docker image from scratch, we will use a highly efficient pattern: injecting a lightweight Node.js API runtime directly into a standard container using a ConfigMap. Finally, we will expose the application using a LoadBalancer Service to perfectly mimic a production cloud environment.

### Your Tasks
* Deploy a simple API.
* Create a Service.
* Add configuration through a ConfigMap.
* Inspect logs and events.

---

## Step 1: Define the Configuration and Secrets

Real APIs require both standard settings and sensitive credentials. We will create a Secret for our mock API key, and a ConfigMap to hold our actual Node.js application code and standard settings.

Create a file named `secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: api-secrets
type: Opaque
stringData:
  API_KEY: "super-secret-course-key-123"
  ```

Create a file named `configmap.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: node-api-config
data:
  server.js: |
    const http = require('http');
    const fs = require('fs');
    const port = 8080;

    const config = JSON.parse(fs.readFileSync('/app/settings.json', 'utf8'));

    // The secret injected by Kubernetes as an environment variable
    const validApiKey = process.env.API_KEY || "Missing Key!";

    const server = http.createServer((req, res) => {
      console.log(`[API LOG] ${req.method} request for ${req.url}`);
      
      // Route 1: Health Check Endpoint (Open to the public)
      if (req.url === '/health') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        return res.end(JSON.stringify({ status: "UP", healthy: true }) + '\n');
      }
      
      // Authentication Gateway (Protects endpoints below this line)
      const clientApiKey = req.headers['x-api-key'];
      
      if (clientApiKey !== validApiKey) {
        console.log(`[AUTH FAILED] Provided key: ${clientApiKey}`);
        res.writeHead(401, { 'Content-Type': 'application/json' });
        return res.end(JSON.stringify({ 
          error: "Unauthorized", 
          message: "Access Denied: Missing or invalid x-api-key header." 
        }) + '\n');
      }
      
      // Route 2: Main API Endpoint (Protected)
      if (req.url === '/' || req.url === '/api') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
          course: config.courseName,
          message: config.welcomeMessage,
          status: "Successfully Authenticated!"
        }) + '\n');
      } 
      // Route 3: 404 Error Handler
      else {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: "Not Found", status: 404 }) + '\n');
      }
    });

    server.listen(port, () => {
      console.log(`Node.js API starting on port ${port}...`);
    });

  settings.json: |
    {
      "courseName": "Kubernetes Fundamentals",
      "welcomeMessage": "Your API is successfully running behind a LoadBalancer!"
    }
```

## Step 2: Deploy the API Application

Now we will deploy the official `node:20-alpine` image. The Deployment acts as our blueprint, instructing Kubernetes to mount our ConfigMap as a file directory and inject our Secret as an environment variable.

Create a file named `deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-node-api
spec:
  replicas: 1
  selector:
    matchLabels:
      app: node-api
  template:
    metadata:
      labels:
        app: node-api
    spec:
      containers:
      - name: api
        image: node:20-alpine
        workingDir: /app
        command: ["node", "server.js"]
        ports:
        - containerPort: 8080
        env:
        - name: API_KEY
          valueFrom:
            secretKeyRef:
              name: api-secrets
              key: API_KEY
        volumeMounts:
        - name: config-volume
          mountPath: /app 
      volumes:
      - name: config-volume
        configMap:
          name: node-api-config
```

## Step 3: Expose the Application (LoadBalancer)

To make our API reachable from outside the cluster, we will use a `LoadBalancer` Service. If you are using K8s for your local environment, its built-in ServiceLB will automatically bind this to your host node's IP—giving you a cloud-like experience immediately.

Create a file named `service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: node-api-svc
spec:
  selector:
    app: node-api
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  type: LoadBalancer
```

## Step 4: Deploy and Test

Apply the configurations to your cluster. Order matters: the Secret and ConfigMap must exist before the Deployment attempts to use them.

```bash
kubectl apply -f secret.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

Watch your Service spin up. You are waiting for the `EXTERNAL-IP` to change from `<pending>` to an actual IP address (or `localhost`/`127.0.0.1`).

```bash
kubectl get svc node-api-svc -w
```

Once the external IP is assigned, query your API directly from your terminal:

```bash
curl http://<YOUR_EXTERNAL_IP>
```
*You should see the dynamic JSON response, proving both the ConfigMap and Secret were loaded correctly!*

## Step 5: Inspect Logs and Events

A crucial part of deployment is verification. Let's inspect the traffic we just generated and view the cluster scheduling events.

Check the Node.js application logs:
```bash
kubectl logs -l app=node-api
```
*You will see the startup message and the `[API LOG]` entries generated by your curl command.*

Inspect the cluster events to view the chronological lifecycle of your deployment:
```bash
kubectl get events --sort-by='.metadata.creationTimestamp'
```

---
**Congratulations!** 
You have successfully deployed a functional, configured, and exposed microservice. 
