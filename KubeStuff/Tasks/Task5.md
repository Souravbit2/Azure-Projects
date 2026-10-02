Ubuntu 22.04 Desktop (ESX)
1 Hr 23 Min Remaining
Deploying and configuring Traefik
In this exercise, you will deploy and configure Traefik as an ingress controller in Kubernetes, enabling routing of external traffic to internal services.

The tasks presented in this exercise include:

Create a Namespace for Traefik
Apply the Configuration Files
Verify the Deployment
Configure Local DNS for Testing
Test the Setup
Task 1: Create a Namespace for Traefik
In a terminal use the following command and press Enter: kubectl create namespace traefik

Create the Main Traefik Configuration file called traefik.yaml by using the command sudo vim traefik.yaml

Add the following to the traefik.yaml file in the editor then press the Escape key and type :wq then press the Enter key to commit and close the file and return to the terminal.

apiVersion: apps/v1
kind: Deployment
metadata:
  name: traefik
  namespace: traefik
  labels:
    app: traefik
spec:
  replicas: 1
  selector:
    matchLabels:
      app: traefik
  template:
    metadata:
      labels:
        app: traefik
    spec:
      containers:
      - name: traefik
        image: traefik:v2.6
        args:
        - "--configFile=/etc/traefik/traefik.yml"
        ports:
        - name: web
          containerPort: 80
        - name: websecure
          containerPort: 443
        volumeMounts:
        - name: config
          mountPath: /etc/traefik
      volumes:
      - name: config
        configMap:
          name: traefik-config
If you experience any difficulties using the copy-to-text feature in the instructions panel, you can find and copy the same code shown above via the Traefik Application.docx file available on the virtual machine desktop. With the file open, select the text you wish to copy and press the keyboard shortcut CTRL + C to copy the contents and then back in the terminal window use keyboard shortcut CTRL + V to paste.

This file defines the Traefik deployment with container specifications, resource limits, and other deployment parameters.

Create the Traefik Service Configuration file called traefikservice.yaml by using the command sudo vim traefikservice.yaml
Add the following to the traefikservice.yaml file in the editor. To commit your changes and close the file, press the Escape key and type :wq then press the Enter key.
apiVersion: v1
kind: Service
metadata:
  name: traefik
  namespace: traefik
spec:
  type: NodePort
  selector:
    app: traefik
  ports:
    - name: web
      port: 80
      targetPort: web
      nodePort: 30080
    - name: websecure
      port: 443
      targetPort: websecure
      nodePort: 30443
If you experience any difficulties using the copy-to-text feature in the instructions panel, you can find and copy the same code shown above via the Traefik Application.docx file available on the virtual machine desktop. With the file open, select the text you wish to copy and press the keyboard shortcut CTRL + C to copy the contents and then back in the terminal window use keyboard shortcut CTRL + V to paste.

This file exposes the Traefik pods to the cluster and potentially external traffic

Create the Traefik ConfigMap file called traefikconfigmap.yaml by using the command sudo vim traefikconfigmap.yaml
Add the following to the traefikconfigmap.yaml file in the editor. To commit your changes and close the file, press the Escape key and type :wq then press the Enter key.
apiVersion: v1
kind: ConfigMap
metadata:
  name: traefik-config
  namespace: traefik
data:
  traefik.yml: |
    entryPoints:
      web:
        address: ":80"
      websecure:
        address: ":443"

    providers:
      kubernetesIngress:
        ingressClass: "traefik"

    log:
      level: "DEBUG"

    api:
      insecure: true
If you experience any difficulties using the copy-to-text feature in the instructions panel, you can find and copy the same code shown above via the Traefik Application.docx file available on the virtual machine desktop. With the file open, select the text you wish to copy and press the keyboard shortcut CTRL + C to copy the contents and then back in the terminal window use keyboard shortcut CTRL + V to paste.

This file contains configuration parameters for Traefik.

Create the Traefik Ingress file called traefikingress.yaml by using the command sudo vim traefikingress.yaml
Add the following to the traefikingress.yaml file in the editor. To commit your changes and close the file, press the Escape key and type :wq then press the Enter key.
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  namespace: default
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: "web,websecure"
spec:
  rules:
  - host: my-app.example.com  # Replace with your domain or use a local setup
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-service
            port:
              number: 9090
  tls:
  - hosts:
    - my-app.example.com  # Replace with your domain or use a local setup
secretName: my-app-tls  # Optional, used if you have TLS certificates
If you experience any difficulties using the copy-to-text feature in the instructions panel, you can find and copy the same code shown above via the Traefik Application.docx file available on the virtual machine desktop. With the file open, select the text you wish to copy and press the keyboard shortcut CTRL + C to copy the contents and then back in the terminal window use keyboard shortcut CTRL + V to paste.

This file defines how external traffic should be routed to your services.

Task 2: Apply the Configuration Files
Apply the deployment file by typing the following command in a terminal window and then press Enter:
kubectl apply -f traefik.yaml -n traefik
Apply the service file by typing the following command in a terminal window and then press Enter:
kubectl apply -f traefikservice.yaml -n traefik
Apply the ConfigMap file by typing the following command in a terminal window and then press Enter:
kubectl apply -f traefikconfigmap.yaml -n traefik
Apply the Ingress Resource file by typing the following command in a terminal window and then press Enter:
kubectl apply -f traefikingress.yaml
Task 3: Verify the Deployment
Check if the pods are running by typing the following command in a terminal window and then press Enter:
kubectl get pods -n traefik
Check the service details by typing the following command in a terminal window and then press Enter:
kubectl get svc -n traefik
Get more details about your deployment by typing the following command in a terminal window and then press Enter:
kubectl get all -n traefik
Check the ingress resource by typing the following command in a terminal window and then press Enter:
kubectl describe ingress my-app-ingress
Task 4: Configure Local DNS for Testing
In a terminal window, type the following command and then press Enter:
sudo vi /etc/hosts
In the /etc/hosts file, add the following entry:
127.0.0.1    my-app.example.com
Task 5: Test the Setup
In a terminal window, type the following commands and then press Enter:
curl http://my-app.example.com
curl -s -H "Content-Type: application/json" -X POST -d '{"key":"value"}' http://my-app.example.com:9090/api/data
You can also do tests with multiple requests to verify load balancing:
for i in {1..10}; do
  curl -s -H "Content-Type: application/json" -X POST -d '{"key":"value"}' \
  http://my-app.example.com:9090/api/data
  sleep 1s
done
Check your work
Check each box to confirm completion of the task.

1. Create a Namespace for Traefik
2. Apply the Configuration Files
3. Verify the Deployment
4. Configure Local DNS for Testing
5. Test the Setup
Congratulations! You have completed the lab. Select 'End' below to close the lab.