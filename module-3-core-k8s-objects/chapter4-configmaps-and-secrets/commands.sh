kubectl exec configmap-secret-demo -- printenv CONTAINER_COLOR

kubectl exec configmap-secret-demo -- printenv CONTAINER_API_KEY

kubectl exec configmap-secret-demo -- cat /etc/nginx/conf.d/default.conf

kubectl exec configmap-secret-demo -- cat /etc/secrets/db-password.txt