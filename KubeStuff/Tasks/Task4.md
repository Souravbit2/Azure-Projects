CKA.1-011: Can You Deploy a Kubernetes Cluster? [Expert]
13 Minutes Remaining 
Retrieve cluster information

You have been automatically signed in to WS2019 as the administrator.

Open the MobaXterm desktop application.

Establish a new SSH session to the k8s-master1 virtual machine as the administrator using Passw0rd! as the password, and then when prompted to save the password, select No.

Select the Type Text icon to enter the associated text into the terminal.

k8s-master1 is an Ubuntu Linux virtual machine. When you enter the password, you will not see the password in the terminal.

This Challenge Lab contains a fully functional Kubernetes cluster environment. The k8s-master1 virtual machine is the cluster master node, and the k8s-worker1 and k8s-worker2 virtual machines are the cluster worker nodes. All commands against the cluster will be executed on the master node.

Retrieve a list of the cluster nodes, and then save the output in a file named nodes by using the Linux > redirect command.
Retrieve a list of the pods that are running in all namespaces, and then save the output to a file named getallpods.
Retrieve the running configuration of the etcd-k8s-master1 pod that is running in the kube-system namespace, and then save the output in yaml format to a file named getetcd.
Check your work
Determine the number of pods that are running in all namespaces in the cluster, and then record your answer in the following text box:

12
Determine the number of namespaces that are defined in the cluster, and then record your answer in the following text box:

4
Determine the number of pods that are running on the k8s-master1 node, and then record your answer in the following text box:

4
CKA.1-011: Can You Deploy a Kubernetes Cluster? [Expert]
13 Minutes Remaining 
Create resources in a cluster

Create a pod named pod1 that contains an nginx Docker container image.
Create a pod named pod2 that contains an httpd Docker container image and a label named os=alpine.
Ensure that you are in the /home/administrator directory.

Display the contents of the rs.yaml ReplicaSet definition file.

Create a pod ReplicaSet by using the rs.yaml file.

Display the contents of the webservers.yaml Deployment definition file.

Create a Deployment by using the webservers.yaml file.

Create a Deployment definition file named database.yaml for a deployment named database that contains a redis Docker container image.
Create a Deployment by using the database.yaml file.
Check your work
Determine the number of pods that are running in the default namespace, and then record your answer in the following text box:

8
Determine the number of ReplicaSets that are running in the default namespace, and then record your answer in the following text box:

3
CKA.1-011: Can You Deploy a Kubernetes Cluster? [Expert]
13 Minutes Remaining 
Organize cluster resources

Create a namespace named finance.
Create a pod named pod3 in the finance namespace that contains a redis Docker container image and a label named app=accounting.
Create a ReplicaSet in the finance namespace by using the rs.yaml ReplicaSet definition file.
Create a namespace named marketing.
Create a deployment named intranet in the marketing namespace that contains an httpd Docker container image.
Check your work
Determine the number of pods that are running in the finance namespace, and then record your answer in the following text box:

5
Determine the number of namespaces that are defined in the cluster, and then record your answer in the following text box:

6
Determine the number of pods that are running in the marketing namespace, and then record your answer in the following text box:

1
Determine the number of ReplicaSets that are running in the marketing namespace, and then record your answer in the following text box:

1
CKA.1-011: Can You Deploy a Kubernetes Cluster? [Expert]
13 Minutes Remaining 
Update cluster resources

Update the intranet deployment in the marketing namespace to deploy an nginx image instead of an httpd image.
Scale the webservers deployment in the default namespace to increase the number of pod replicas to 4.
Scale the rs ReplicaSet in the default namespace to decrease the number of pod replicas to 2.
Check your work
Determine the total number of ReplicaSets in the marketing namespace and then record your answer in the following text box:

3
CKA.1-011: Can You Deploy a Kubernetes Cluster? [Expert]
13 Minutes Remaining 
Roll back a Deployment

Roll back the intranet deployment in the marketing namespace to its previous version.
Check your work
Determine the container image that is running in the intranet Deployment, and then record your answer in the following text box:

nginx
CKA.1-011: Can You Deploy a Kubernetes Cluster? [Expert]
12 Minutes Remaining 
Summary
Congratulations, you have completed the Can You Deploy Resources in a Kubernetes Cluster? Challenge Lab.

You have accomplished the following:

Retrieved cluster resources by using kubectl.
Created a pod in the default namespace.
Created a pod ReplicaSet in the default namespace.
Created a Deployment in the default namespace.
Created a Deployment definition file.
Created a namespace.
Created objects in a namespace.
Updated the container image in a Deployment.
Scaled a Deployment.
Scaled a ReplicaSet
Rolled back a Deployment to a previous version.

Submitting your lab
To ensure your lab is recorded as complete, select Submit below. Exiting [X] the lab will result in an incomplete status.

Once you select Submit, you will not be able to return to this Challenge Lab.


Your feedback is important!
As you end your Challenge Lab, please take a few minutes to complete the short survey that will appear in the next window. Alternatively, you may provide your feedback directly to Challenge Labs feedback.


Looking for your next Challenge Lab?
Below are recommended Challenge Labs to try next.

Getting Started with Kubernetes Cluster Administration [Getting Started]
Install Kubernetes Cluster Components [Guided]
Initialize a Kubernetes Cluster [Guided]
Retrieve Kubernetes Core Component Information by Using kubectl [Guided]
Can You Install and Configure a Kubernetes Cluster? [Advanced]
Create Cluster Objects by Using Imperative Commands [Guided]
Create Cluster Objects by Using Declarative Commands [Guided]
Can You Create Objects in a Kubernetes Cluster? [Advanced]
Create a Kubernetes Cluster Deployment [Guided]
Organize Kubernetes Cluster Resources by Using Namespaces [Guided]
Can You Manage Resources in a Kubernetes Cluster? [Advanced]
Can You Deploy a Kubernetes Cluster? [Expert]
