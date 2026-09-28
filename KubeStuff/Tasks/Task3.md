2CKA.1-008: Create a Kubernetes Cluster Deployment [Guided]
41 Minutes Remaining 
Create a ReplicaSet


Hints Enabled

No  Yes

You have been automatically signed in to WS2019 as the administrator.

Open the MobaXterm desktop application.
Establish a new SSH session to the k8s-master1 virtual machine as the administrator by using Passw0rd! as the password, and then when prompted to save the password, select No.
Select the Type Text icon to enter the associated text into the terminal.

Expand this hint for guidance on establishing a new SSH session.
k8s-master1 is an Ubuntu Linux virtual machine. When you enter the password, you will not see the password in the terminal.

This challenge contains a fully functional Kubernetes cluster environment. The k8s-master1 virtual machine is the cluster master node, and the k8s-worker1 and k8s-worker2 virtual machines are the cluster worker nodes. All commands against the cluster will be executed on the master node by using the Kubernetes kubectl command-line tool.

Display the contents of the rs.yaml file by using the Linux cat command, and then review the ReplicaSet definition that is contained in the file.
Expand this hint for guidance on displaying the contents of a file.
The rs.yaml file defines a ReplicaSet named rs, and it defines a pod that contains an nginx Docker container image. The rs.yaml file contains a replicas setting that specifies four pod replicas in the ReplicaSet.

The ReplicaSet .yaml file

A .yaml file contains key/value pairs that you can use to define cluster objects. A Kubernetes .yaml file-or manifest-must contain four fields named apiVersion, kind, metadata, and spec.

YAML™ (YAML Ain't Markup Language) is a flexible, human-readable data serialization standard that you can use to store data that describes a desired object state or configuration. YAML structure consists of indentations and data key/value pairs that are separated by a colon.

Repeat the above command and then print the output to a file named rs-review.txt.

Create the rs ReplicaSet by using the rs.yaml file, the kubectl apply command, and the -f flag.

Expand this hint for guidance on creating a ReplicaSet by using a .yaml file.
A ReplicaSet maintains a stable set of pod replicas that are running in the cluster at any given time. A ReplicaSet can contain a single pod or multiple instances of a pod. Multiple pods can share a single workload and provide load balancing.

You can use the apply command to declaratively create or update cluster resources. You use the -f flag to instruct the apply command to update the cluster state by using a configuration file passed to it as an argument. The file can be a local file or a remote file where the filename is expressed in the form of a URL.

more...
Repeat the above command and then print the output to a file named rs-replica-create.txt.

Display the replicasets that are running in the cluster by using the kubectl get command.

Expand this hint for guidance on displaying the ReplicaSets that are running in the cluster.
Repeat the above command and then print the output to a file named replicasets-report.txt.

Display the pods that are running in the cluster by using the kubectl get command, and then record the name of one of the pods in the Pod Name text box.

Pod Name
Pod Name

Delete <pod> by using the kubectl delete command.

Expand this hint for guidance on deleting a pod.
You can use the delete command to delete a cluster object.

Display the pods that are running in the cluster by using the kubectl get command.
The ReplicaSet maintained the number of running replica pods as specified in the rs.yaml file. Pod replicas contain a unique name suffix to distinguish the pod in the cluster.

Repeat the above command and then print the output to a file named replicasets-renew-report.txt.
Check your work
Confirm that you reviewed the contents of the rs.yaml file.

Confirm that you created a ReplicaSet named rs.

Confirm that you displayed the ReplicaSets that are running in the cluster.

Confirm that you deleted a pod replica.

Confirm that you verified that a replica pod was recreated by the ReplicaSet.

CKA.1-008: Create a Kubernetes Cluster Deployment [Guided]
41 Minutes Remaining 
Create a Deployment


Hints Enabled

No  Yes

Display the contents of the webservers.yaml file by using the cat command.
As with a ReplicaSet, you define a Deployment by using a .yaml file. You can include the definition of a ReplicaSet when you define the Deployment.

The webserver.yaml file

Repeat the above command and then print the output to a file named webservers-review.txt.

Create a Deployment named webservers by using the webservers.yaml file, the kubectl apply command, and the -f flag.

Expand this hint for guidance on creating a Deployment by using a .yaml file.
A Deployment is an object that represents a set of identical pods. A Deployment creates a ReplicaSet, and it is considered a best practice to manage ReplicaSets by using a Deployment.

Repeat the above command and then print the output to a file named webservers-deployment-create.txt.

Display the pods that are running in the cluster by using the kubectl get command.

If the kubectl get pods command returns a status of ContainerCreating for one of the pods, run the command again. This status indicates that a pod is still in the creation stage.

Repeat the above command and then print the output to a file named webservers-pods-report.txt.

Display the deployments that are running in the cluster by using the kubectl get command.

Display the replicasets that are running in the cluster by using the kubectl get command.

The webserver ReplicaSet was created by the webserver Deployment.

Repeat the above command and then print the output to a file named webservers-replicasets-report.txt.
Check your work
Confirm that you retrieved the contents of the webservers.yaml file.

Confirm that you created a Deployment named webservers.

Confirm that you displayed the Deployment pods that are running in the cluster.

Confirm that you displayed the ReplicaSets that are running in the cluster.

CKA.1-008: Create a Kubernetes Cluster Deployment [Guided]
41 Minutes Remaining 
Update a Deployment


Hints Enabled

No  Yes

Update the webservers deployment to deploy an httpd image instead of an nginx image by using the kubectl set command and the image resource type.
Expand this hint for guidance on updating a Deployment.
You can use the set command to update a pod container image. You use the old_image_name=new_image_name syntax to specify the updated image.

Retrieve the rollout status of the webservers deployment update by using the kubectl rollout status command.
Expand this hint for guidance on retrieving the rollout status of a Deployment.
A Deployment creation or update triggers a Deployment rollout.

Repeat the above command and then print the output to a file named deployment-rollout-status.txt.

Retrieve the running configuration of the webservers deployment by using the kubect describe command.

Expand this hint for guidance on retrieving information about a Deployment.
You can use the output of the describe command to verify that the update was successful.

Repeat the above command and then print the output to a file named deployment-updated-report.txt.

Increase the number of pod replicas in the webservers deployment to 4 by using the kubectl scale command and the --replicas= option.

Expand this hint for guidance on scaling the number of pod replicas in a Deployment.
You use the scale command to increase or decrease the number of pod replicas in a Deployment. You use the --replicas= option to specify the number of pod replicas.

Repeat the above command and then print the output to a file named deployment-scale-report.txt.

Display the pods that are running in the cluster by using the kubectl get command.

Display the replicasets that are running in the cluster by using the kubectl get command.

There are now two ReplicaSets named webservers. One of the ReplicaSets shows a zero value in the DESIRED, CURRENT, and READY columns.

The ReplicaSets in the cluster

During a rolling update, a new ReplicaSet that represents the desired state of the updated pod is created. The zero-value ReplicaSet represents the previous ReplicaSet-the pre-update ReplicaSet. If you need to roll back the Deployment state, the Deployment will use the information in the zero-value ReplicaSet to perform a rollback to the previous revision.

Retrieve event information about the webservers deployment by using the kubectl describe command.
The information for the webservers Deployment event shows the scaling up of a new ReplicaSet and the scaling down of the original ReplicaSet. During a rolling update, pods in the original ReplicaSet are destroyed, and then new, updated pods are created in the new ReplicaSet. Rolling updates ensure that applications in a pod are uninterrupted during an update.

The output of the describe command showing the rolling update

Retrieve information about the strategy type of the webservers deployment update by using the kubectl describe command and the Linux grep command.
Expand this hint for guidance on retrieving information about the strategy type of a Deployment update.
Repeat the above command and then print the output to a file named deployment-strategy-type.txt.

The following screenshot displays the strategy type of the Deployment update:

The strategy type of the update

You can use the grep -i option to filter text input regardless of case.

You can update a Deployment by using a rolling or a recreate strategy type. The recreate strategy type terminates all pods in the ReplicaSet at once and then recreates them. When you use this strategy type, access to the pod is not guaranteed during the update. The RollingUpdate strategy type is the default for a Deployment.

more...
Check your work
Confirm that you updated the webservers.yaml file to use a new image.

Confirm that you verified the rollout status of the webservers Deployment.

Confirm that you verified the success of the update.

Confirm that you increased the number of replica pods in the Deployment.

Confirm that you retrieved information about the strategy type of the Deployment update.

CKA.1-008: Create a Kubernetes Cluster Deployment [Guided]
41 Minutes Remaining 
Roll back a Deployment


Hints Enabled

No  Yes

Roll back the webservers deployment to the previous version by using the kubectl rollout undo command.
Expand this hint for guidance on rolling back a Deployment to its previous version.
You can use the rollout undo command to return a Deployment to a previous state.

You can use a Deployment rollback to revert the replica pods in a Deployment to a previous, known working state in the event that an application in a pod is not functioning properly. During a Deployment rollback, pods are incrementally destroyed in the current ReplicaSet, and then the pods are recreated by using information from the previous ReplicaSet. By default, Kubernetes can store 10 versions of a ReplicaSet. You can set the revision history limit for a replica in the definition of the Deployment.

more...
Display the replicasets that are running in the cluster by using the kubectl get command.

Display the pods that are running in the cluster by using the kubectl get command.

Verify the success of the rollback by using the kubectl describe command and the grep command to retrieve information about the image in the webservers deployment.

Expand this hint for guidance on retrieving information about the image in a Deployment.
Repeat the above command and then print the output to a file named deployment-image.txt.
Check your work
Confirm that you rolled back a Deployment.

Confirm that you verified the success of the rollback.

CKA.1-008: Create a Kubernetes Cluster Deployment [Guided]
40 Minutes Remaining 
Delete a Deployment


Hints Enabled

No  Yes

Delete the webservers deployment by using the kubectl delete command.
Expand this hint for guidance on deleting a Deployment.
When you delete a pod replica in a Deployment by using the kubectl delete pods command, the Deployment ReplicaSet will create a replacement pod replica. To delete a pod replica in a Deployment, you must delete the Deployment.

Display the pods that are running in the cluster by using the kubectl get command.
If the kubectl get pods command returns a status of Terminating for one of the pods, run the command again. This status indicates that a pod is still in the termination stage.

A pod in the terminating state

Repeat the above command and then print the output to a file named pods-delete-report.txt.

Display the deployments that are running in the cluster by using the kubectl get command.

Repeat the above command and then print the output to a file named deployments-delete-report.txt.
Check your work
Confirm that you deleted the webservers Deployment.

Confirm that you verified that the pod replicas in the Deployment were deleted.

CKA.1-008: Create a Kubernetes Cluster Deployment [Guided]
40 Minutes Remaining 
Summary
Congratulations, you have completed the Create a Kubernetes Deployment Challenge Lab.

You have accomplished the following:

Created a ReplicaSet.
Created a Deployment.
Updated a Deployment.
Rolled back a Deployment.
Deleted a Deployment.

Ending your lab
To ensure your lab is recorded as complete, select Submit or End below. Exiting [X] the lab will result in an incomplete status.

Once you select Submit or End, you will not be able to return to this Challenge Lab.


Your feedback is important!
As you end your Challenge Lab, please take a few minutes to complete the short survey that will appear in the next window. Alternatively, you may provide your feedback directly to Challenge Labs feedback.


Looking for your next Challenge Lab?
Below are recommended Challenge Labs to try next.

Create a Kubernetes Cluster Namespace [Guided]

Create Cluster Objects by Using Declarative Commands [Guided]

Can You Deploy a Kubernetes Cluster Hosted Application? [Advanced]