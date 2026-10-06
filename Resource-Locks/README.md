# Resource-Locks
Azure Resource Locks are a critical feature for preventing accidental deletion or modification of your valuable Azure resources. They provide an additional layer of protection on top of Azure Role-Based Access Control (RBAC) by overriding any user permissions, ensuring that specific actions are blocked regardless of the user's role.

Here's how to create and manage Azure Resource Locks, covering the topics you requested:

## Understanding Azure Resource Locks

Azure Resource Locks operate at three different scopes:

  * **Subscription:** Applies the lock to all resource groups and resources within the entire subscription.
  * **Resource Group:** Applies the lock to all resources within that specific resource group.
  * **Resource:** Applies the lock to an individual resource.

When a lock is applied at a parent scope (e.g., resource group), all resources within that scope inherit the same lock. If multiple locks are applied to a resource through inheritance, the most restrictive lock takes precedence.

There are two types of Azure Resource Locks:

1.  **Delete Lock (CanNotDelete):** This lock prevents users from deleting the resource, resource group, or subscription, but still allows them to modify its configuration.
2.  **Read-Only Lock (ReadOnly):** This lock restricts users to only reading the resource's configuration. It prevents any modifications or deletions. This is similar to giving all authorized users the "Reader" RBAC role.

**Important Note:** Resource Locks only apply to **control plane operations** (management actions that go through Azure Resource Manager, like creating, updating, or deleting resources). They do *not* apply to **data plane operations** (actions taken directly on the service instance, like deleting data within a storage account or stopping a VM from within the guest OS).

## How to Make a Delete Lock

A Delete Lock (CanNotDelete) prevents the deletion of a resource, resource group, or subscription.

### Using Azure Portal

1.  **Navigate to the Resource:** Go to the Azure portal (portal.azure.com) and navigate to the resource, resource group, or subscription you want to lock.
2.  **Select "Locks":** In the settings blade (left-hand menu) for the selected item, find and click on **"Locks"**.
3.  **Add a Lock:** Click the **"+ Add"** button.
4.  **Configure the Lock:**
      * **Lock name:** Provide a descriptive name for your lock (e.g., `PreventVMDemoDeletion`).
      * **Lock type:** Select **"Delete"**.
      * **Notes (Optional):** Add any relevant notes explaining why the lock is being applied.
5.  **Click "OK" or "Apply".**

### Created a delete lock for a VM
I've navigated to the VM's blade and chose Locks under settings and created a DELETE lock. The lock should prevent deletion but allow other modifications.

<img width="878" height="188" alt="image" src="https://github.com/user-attachments/assets/8bad2a66-cdf8-4c2f-a380-4b5b6b1a6e65" />

When attempted to delete:

<img width="408" height="261" alt="image" src="https://github.com/user-attachments/assets/5e2788fb-34f3-4411-b91d-278b91e5275e" />

When attempted to restart:

<img width="410" height="111" alt="image" src="https://github.com/user-attachments/assets/bb42283c-84c4-459b-bd18-5329ce8d8953" />

When attempted to deassociate the public ip address:

Before: <img width="370" height="213" alt="image" src="https://github.com/user-attachments/assets/3b64dbac-a0d2-4b57-848a-f2564aacb027" />

After dessociating:<img width="407" height="124" alt="image" src="https://github.com/user-attachments/assets/2777e27d-28c2-4482-aad8-87a9db2c12e0" /><img width="377" height="244" alt="image" src="https://github.com/user-attachments/assets/f39845ea-82a3-4ca2-a474-b3363907a784" />

The dessociation actually happended and wans't prevented , meaning the delete lock is working as intended.

## How to Create a Read-Only Lock

A Read-Only Lock (ReadOnly) prevents both modification and deletion of a resource, resource group, or subscription.

### Using Azure Portal

1.  **Navigate to the Resource:** Go to the Azure portal and navigate to the resource, resource group, or subscription you want to lock.
2.  **Select "Locks":** In the settings blade (left-hand menu) for the selected item, find and click on **"Locks"**.
3.  **Add a Lock:** Click the **"+ Add"** button.
4.  **Configure the Lock:**
      * **Lock name:** Provide a descriptive name for your lock (e.g., `MyCriticalVMRoLock`).
      * **Lock type:** Select **"Read-only"**.
      * **Notes (Optional):** Add any relevant notes explaining why the lock is being applied.
5.  **Click "OK" or "Apply".**

### Created a read-only lock for a VM

With the lock on the VM can't be restarted, stopped, deleted even the associated resource group also can't be deleted regardless at what level you set the lock (resource,resource group etc.). Below are some error recevied performing each action and it threw error each time complaining it couldn't delete the item.

when attempted to STOP the VM:

<img width="385" height="169" alt="image" src="https://github.com/user-attachments/assets/1f8e884b-58e5-4133-91b5-d6318e2c85a7" />

when attempted to DELETE the VM:

<img width="402" height="234" alt="image" src="https://github.com/user-attachments/assets/bfebac3b-3993-4291-b7b5-62321c52337d" />


when attempted to RESTART the VM:

<img width="401" height="200" alt="image" src="https://github.com/user-attachments/assets/1ce0d984-d4a9-45a1-9bf9-0f683b4c2412" />


when attempted to delete the associated Resource Group of the VM:

<img width="429" height="159" alt="image" src="https://github.com/user-attachments/assets/47d4c9b9-7aee-4411-b6c5-8d54f564aa49" />


## Removal of the Locks

To delete or modify a locked resource, you must first remove the lock. You need the `Microsoft.Authorization/locks/delete` permission to remove a lock. Roles like "Owner" or "User Access Administrator" typically have this permission.

### Using Azure Portal

1.  **Navigate to the Resource:** Go to the Azure portal and navigate to the resource, resource group, or subscription that has the lock you want to remove.
2.  **Select "Locks":** In the settings blade, click on **"Locks"**.
3.  **Delete the Lock:** You will see a list of applied locks. Select the lock you wish to remove and click the **"Delete"** button (trash can icon).
4.  **Confirm Deletion:** Confirm the deletion when prompted.

### Using Azure CLI

```bash
az lock delete \
  --name <LockName> \
  --resource-group <ResourceGroupName> \
  --resource <ResourceName> \
  --resource-type <ResourceType>
```

**Example for a Virtual Machine lock:**

```bash
az lock delete \
  --name MyVMLockDelete \
  --resource-group MyResourceGroup \
  --resource MyVM \
  --resource-type Microsoft.Compute/virtualMachines
```

### Using Azure PowerShell

```powershell
Remove-AzResourceLock -LockName "<LockName>" `
  -ResourceGroupName "<ResourceGroupName>" `
  -ResourceName "<ResourceName>" `
  -ResourceType "<ResourceType>" -Force
```

**Example for a Virtual Machine lock:**

```powershell
Remove-AzResourceLock -LockName "MyVMLockDelete" `
  -ResourceGroupName "MyResourceGroup" `
  -ResourceName "MyVM" `
  -ResourceType "Microsoft.Compute/virtualMachines" -Force
```

## The Virtual Machine being deleted

When a Delete Lock (CanNotDelete) is applied to a Virtual Machine (VM) or its parent Resource Group, any attempt to delete that VM will fail.

**Scenario:** You have a VM named `MyVM` in `MyResourceGroup`, and you apply a `CanNotDelete` lock to `MyVM`.

  * If someone tries to delete `MyVM` from the Azure portal, they will receive an error message indicating that the resource is locked and cannot be deleted.
  * If someone tries to delete `MyResourceGroup` while `MyVM` (or the resource group itself) has a `CanNotDelete` lock, the entire deletion operation of the resource group will be blocked, even if other resources in the group are not locked.

**This mechanism ensures that critical virtual machines, which often host essential applications or data, are protected from accidental or unauthorized removal. Remember that a "Read-Only" lock on a VM would prevent both deletion and modification (e.g., stopping, starting, resizing) of the VM through the Azure control plane.**
