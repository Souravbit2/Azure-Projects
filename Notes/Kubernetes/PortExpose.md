From your kubectl get svc --all-namespaces output, the PORT(S) column follows this format:

port:nodePort/protocol


or for ClusterIP services:

port/protocol


Let's break down each service.

1. order-service
TYPE: ClusterIP
PORT(S): 3000/TCP

Meaning
Field	ValueService Port	3000
Protocol	TCP
Cluster Accessible	Yes
External Accessible	No
Traffic Flow
Pod -> order-service:3000 -> Order Pod


Example:

curl http://order-service:3000


or

curl http://10.0.233.133:3000


Only pods inside the cluster can reach it.

2. product-service
TYPE: ClusterIP
PORT(S): 3002/TCP

Meaning
Item	ValueService Port	3002
Protocol	TCP
External Access	No
Traffic Flow
Pod
  |
  +--> product-service:3002
          |
          +--> Product Pod


Internal microservices call:

http://product-service:3002

3. rabbitmq
TYPE: ClusterIP
PORT(S): 5672/TCP, 15672/TCP


RabbitMQ exposes two different ports.

Port 5672
5672/TCP

Purpose

RabbitMQ messaging protocol (AMQP)

Applications connect here.

Example:

order-service
        |
        +--> rabbitmq:5672


Connection string:

amqp://rabbitmq:5672

Port 15672
15672/TCP

Purpose

RabbitMQ Web Management UI

Access URL (inside cluster):

http://rabbitmq:15672


You can see:

Queues
Exchanges
Connections
Consumers
4. store-front
TYPE: LoadBalancer
EXTERNAL-IP: 20.241.162.120
PORT(S): 80:31463/TCP


This is the most important one.

Port Mapping
80:31463/TCP


means:

Service Port	NodePort	Protocol80	31463	TCP
Traffic Flow
Internet
    |
20.241.162.120:80
    |
Azure Load Balancer
    |
NodePort 31463
    |
Store Front Pod

External Access

Users browse:

http://20.241.162.120


The Azure Load Balancer sends traffic to:

<Node_IP>:31463


And Kubernetes forwards it to store-front pods.

Why two ports?

Because every LoadBalancer service internally uses a NodePort.

External Port   = 80
NodePort        = 31463
Container Port  = (targetPort)


You can see the exact targetPort with:

kubectl get svc store-front -n azure-store -o yaml


Example:

ports:
- port: 80
  targetPort: 8080
  nodePort: 31463


Flow becomes:

20.241.162.120:80
        ↓
Node:31463
        ↓
Pod:8080

5. helloworlddeployment
TYPE: LoadBalancer
PORT(S): 80:31621/TCP,443:31460/TCP


This service exposes both HTTP and HTTPS.

HTTP Mapping
80:31621/TCP

Service Port	NodePort80	31621

Flow:

Internet:80
      ↓
Azure LB
      ↓
NodePort 31621
      ↓
Pod

HTTPS Mapping
443:31460/TCP

Service Port	NodePort443	31460

Flow:

Internet:443
      ↓
Azure LB
      ↓
NodePort 31460
      ↓
Pod


Since the external IP is still pending:

EXTERNAL-IP: <pending>


Azure hasn't yet provisioned the public Load Balancer frontend IP.

Check:

kubectl describe svc helloworlddeployment -n default-1789978700207


and

kubectl get events -A --sort-by=.lastTimestamp

6. kubernetes Service
TYPE: ClusterIP
PORT(S): 443/TCP

ClusterIP: 10.0.0.1


This is the Kubernetes API Server service.

Pods communicate with:

https://kubernetes.default.svc:443


Flow:

Pod
  |
  +--> kubernetes.default.svc:443
               |
               +--> API Server

7. azure-wi-webhook-webhook-service
PORT(S): 443/TCP


This is the Azure Workload Identity Webhook service.

Purpose:

Pod Creation
      |
      +--> Webhook:443
              |
              +--> Inject Azure Identity settings


Only internal cluster communication.

8. kube-dns
PORT(S): 53/UDP,53/TCP


Kubernetes DNS service.

UDP 53

Normal DNS queries.

product-service -> kube-dns:53/UDP

TCP 53

Used when:

DNS response is large
UDP retry fails
Zone transfers

Flow:

Pod
 |
 +--> kube-dns:53
 |
 +--> Resolves product-service

9. metrics-server
PORT(S): 443/TCP


Used by:

kubectl top pod
kubectl top node


Flow:

kubectl top pod
      |
      +--> Metrics Server:443
               |
               +--> Kubelet metrics

Visual Summary
ClusterIP Services
==================
order-service      3000/TCP
product-service    3002/TCP
rabbitmq           5672/TCP (AMQP)
rabbitmq           15672/TCP (UI)
kubernetes         443/TCP
kube-dns           53/TCP,53/UDP
metrics-server     443/TCP
azure-wi-webhook   443/TCP

LoadBalancer Services
=====================
store-front
  External Port : 80
  NodePort      : 31463
  Public IP     : 20.241.162.120

helloworlddeployment
  HTTP  : 80 -> 31621
  HTTPS : 443 -> 31460
  Public IP : Pending

To see the complete mapping up to the container port

Run these read-only commands:

kubectl describe svc store-front -n azure-store

kubectl describe svc order-service -n azure-store

kubectl describe svc product-service -n azure-store

kubectl describe svc rabbitmq -n azure-store


Look for:

Port:
TargetPort:
NodePort:
Endpoints:


That will reveal the full path:

Client Port -> Service Port -> TargetPort -> Container Port


which is the final piece of the port mapping.