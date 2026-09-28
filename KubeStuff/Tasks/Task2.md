CKA.1-002: Initialize a Kubernetes Cluster [Guided]
15 Minutes Remaining
Initialize the Kubernetes control plane


Hints Enabled

No  Yes

You have been automatically signed in to WS2019 as the administrator.

Open the MobaXterm desktop application.
Establish a new SSH session to the k8s-master1 virtual machine as the administrator by using Passw0rd! as the password, and then when prompted to save the password, select No.
Select the Type Text icon to enter the associated text into the terminal.

Expand this hint for guidance on establishing a new SSH session.
k8s-master1 is an Ubuntu Linux virtual machine. When you enter the password, you will not see the password in the terminal.

Repeat the previous step on both k8s-worker1 and k8s-worker2 by using Passw0rd! as the password.
Expand this hint for guidance on using the Mobaxterm tabbed user interface.
You can use the session tabs to switch between established SSH sessions. MobaXterm is an enhanced Windows terminal emulator with a tabbed SSH terminal client.

The Docker engine, Kubernetes kubectl, and kubeadm components have been installed, and swap has been disabled on the three virtual machines. The k8s-master1 virtual machine will serve as the cluster master or control plane node, and k8s-worker1 and k8s-worker2 will serve as cluster worker nodes.

There are several Kubernetes cluster installation and initialization methods available. In this challenge, you will use the kubeadm tool to install and initialize the cluster. Refer to the Kubernetes (K8S) installation documentation for information on the available Kubernetes installation methods.

On k8s-master1, initialize the Kubernetes control plane by using the kubeadm command, pass the flannel overlay network parameter --pod-network-cidr=10.244.0.0/16 as an argument to the command, and then when prompted, enter Passw0rd! as the sudo password.
Expand this hint for guidance on initializing a Kubernetes cluster control plane.
You pass the --pod-network-cidr=10.244.0.0/16 network parameters to the kubeadm init command to set requirements for the flannel installation that you will install in an upcoming task. Flannel is a third-party container network interface (CNI) plugin. Classless Inter-Domain Routing (CIDR) is a representation of an IP address range.

You are prompted for the sudo (superuser) password as this is the first time you are using the sudo prefix to run a command that requires elevated privileges. Subsequent commands in this challenge will require sudo privileges.

The cluster may take some time to initialize. Please be patient.

Do not clear the screen once the cluster has finished initializing. The completed initialization will present bootstrap token information that you will need to join the k8s-worker1 and k8s-worker2 worker nodes to the cluster.

A Kubernetes control plane initialization performs initial pre-flight checks to satisfy control plane initialization requirements. The initialization then generates certificates for secure communication between the cluster components, and it creates manifest files that define the parameters needed to bootstrap the cluster components.

Check your work
Verify that you initialized the cluster control plane.

CKA.1-002: Initialize a Kubernetes Cluster [Guided]
15 Minutes Remaining
Join the cluster nodes


Hints Enabled

No  Yes

On k8s-master1, copy the bootstrap token information-the last two lines of the cluster initialization output.

The bootstrap join token

When you select items in the terminal screen in MobaXterm, the copy function is implied.

Open Notepad, paste the copied token information, and then save the file on the desktop as token.txt.

On k8s-worker1, open an interactive subshell as the root user by using the sudo command, and then when prompted, enter Passw0rd! as the password.

Expand this hint for guidance on opening an interactive subshell.
Paste the copied bootstrap token contents on the command line.
Expand this hint for guidance on pasting the bootstrap token contents.
You will see a message confirming that the k8s-worker virtual machine has successfully joined the Kubernetes cluster as a worker node.

The success message

Wait for k8s-worker1 to join the cluster and then exit the root subshell by using the exit command.

Join k8s-worker2 to the cluster as a worker node, and then exit the root subshell.

All subsequent cluster operations can now be performed on the k8s-master1 master node.

Check your work
Verify that you added k8s-worker1 to the cluster as worker nodes.

Verify that you added k8s-worker2 to the cluster as worker nodes.

CKA.1-002: Initialize a Kubernetes Cluster [Guided]
15 Minutes Remaining
Configure cluster admin privileges


Hints Enabled

No  Yes

On k8s-master1, ensure you are in the home directory by using the cd command.
Expand this hint for guidance on changing to the home directory.
The tilde (~) character represents the home directory of the current user.

Create a hidden directory named kube in the home directory of the administrator by using the mkdir command.
Expand this hint for guidance on creating a hidden directory.
The $HOME variable represents the home directory path of the current user. The . prefix in the directory name indicates that it is a hidden directory.

Copy the /etc/kubernetes/admin.conf file to a new hidden file named kube/config in the home directory of the administrator by using the cp command, and then when prompted, enter Passw0rd! as the password.
Expand this hint for guidance on copying the contents of a file to a new file.
The /etc/kubernetes/admin.conf file contains cluster administration credentials generated during the control plane initialization process. The credentials are copied to a user's home directory to allow that user to perform cluster operations as a regular (non-root) user.

Change the ownership and group of the $HOME/.kube/config file to the administrator by using the chown command.
Expand this hint for guidance on changing the ownership and group of a file.
You can use a colon to specify owner:group when using the chown command.

The administrator user can now execute all kubectl commands against the cluster.

Check your work
Verify that you created the .kube hidden directory.

Verify that you copied the /etc/kubernetes/admin.conf file to the /$HOME/.kube directory.

Verify that you changed the ownership and group of the /$HOME/.kube/config file.

CKA.1-002: Initialize a Kubernetes Cluster [Guided]
15 Minutes Remaining
Install the cluster network plug-in


Hints Enabled

No  Yes

On k8s-master1, display the nodes in the cluster by using kubectl.
Expand this hint for guidance on displaying nodes in a cluster.
The cluster node status returned the names of the three cluster nodes in a NotReady state as the cluster network plug-in is not installed.

The nodes in a NotReady state

Kubectl is the Kubernetes command line tool used to run commands against a Kubernetes cluster.

Type the name of one of the cluster nodes whose status is NotReady into the textbox below. Type the name of one of the cluster nodes whose status is NotReady into the textbox below.

Install the flannel cluster overlay network plug-in from https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml by using kubectl.

Expand this hint for guidance on installing the flannel cluster overlay network plug-in.
The kubectl apply -f command option creates a resource by applying the contents of the specified configuration file.

In addition to the existing IP network, a Kubernetes cluster requires its own network infrastructure that functions as an overlay network. There are several networking vendor solutions that can be deployed on a Kubernetes cluster. In this challenge, you will use the flannel virtual network plug-in.

Display the status of the cluster nodes by using kubectl.
The cluster nodes status displays a Ready state, indicating that the overlay network plug-in has been installed. The Kubernetes cluster is now fully functional.

The cluster nodes in a ready state

Check your work
Confirm that you verified the NotReady state of the cluster nodes.

Verify that you installed the flannel overlay network plug-in.

Confirm that you verified the Ready state of the cluster after installing the overlay network plug-in.

CKA.1-002: Initialize a Kubernetes Cluster [Guided]
15 Minutes Remaining
Summary
Congratulations, you have completed the Initialize a Kubernetes Cluster Challenge Lab.

You have accomplished the following:

Initialized the Kubernetes control plane.
Joined the cluster nodes.
Configured cluster admin privileges.
Installed the cluster network plug-in.

Ending your lab
To ensure your lab is recorded as complete, select Submit or End below. Exiting [X] the lab will result in an incomplete status.

Once you select Submit or End, you will not be able to return to this Challenge Lab.


Your feedback is important!
As you end your Challenge Lab, please take a few minutes to complete the short survey that will appear in the next window. Alternatively, you may provide your feedback directly to Challenge Labs feedback.


Looking for your next Challenge Lab?
Below are recommended Challenge Labs to try next.

Retrieve Kubernetes Core Component Information by Using kubectl [Guided]

Can You Install and Configure a Kubernetes Cluster? [Advanced]