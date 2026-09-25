admin [ ~ ]$ k get svc -o wideNAME            TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE    SELECTORkubernetes      ClusterIP   10.0.0.1       <none>        443/TCP        4d4h   <none>npservice       NodePort    10.0.232.202   <none>        80:30001/TCP   58s    app=webserverwebserver-svc   ClusterIP   10.0.196.80    <none>        80/TCP         27m    app=webserverwhy 

do all of them have different cluster ip ?

This is expected behavior in Kubernetes. ✅

A ClusterIP Service gets its own virtual IP address, independent of Pods or other Services.

From your output:

kubernetes      ClusterIP   10.0.0.1
webserver-svc   ClusterIP   10.0.196.80
npservice       NodePort    10.0.232.202


Each Service has a different ClusterIP because Kubernetes allocates a unique IP for every Service from the cluster's Service CIDR range.

How it works

Think of a Service as a virtual load balancer:

webserver-svc
   10.0.196.80
        |
        +--> Pod A
        +--> Pod B

npservice
   10.0.232.202
        |
        +--> Pod A
        +--> Pod B


Even though webserver-svc and npservice may target the same pods, they are different Services, so they receive different ClusterIPs.

Why does a NodePort Service also have a ClusterIP?

A NodePort Service is actually built on top of a ClusterIP Service.

When you create:

spec:
  type: NodePort


Kubernetes automatically provides:

A ClusterIP for internal cluster communication.
A NodePort for external access.

In your case:

npservice
ClusterIP = 10.0.232.202
NodePort  = 30001


Traffic can reach the same Service through:

Inside cluster:
10.0.232.202:80

Outside cluster:
<NodeIP>:30001

One thing to check

Both Services currently use:

SELECTOR app=webserver


But earlier your pods showed labels like:

run=webserver


Verify whether npservice and webserver-svc actually have endpoints:

kubectl get endpoints webserver-svc
kubectl get endpoints npservice


If you see:

<none>


then the selector doesn't match the pod labels and traffic won't reach the pods.

If you see something like:

10.x.x.x:80,10.x.x.x:80


then everything is working correctly.

Summary
✅ Every Service gets its own unique ClusterIP.
✅ Different Services exposing the same pods still have different ClusterIPs.
✅ NodePort Services also receive a ClusterIP.
✅ Your IPs (10.0.0.1, 10.0.196.80, 10.0.232.202) are normal and expected.

For your lab, run:

kubectl get endpoints webserver-svc npservice


and share the output if you want me to confirm whether the selectors are correctly matching the webserver pods.
