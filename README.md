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

### Using Azure CLI

```bash
az lock create \
  --name <LockName> \
  --lock-type CanNotDelete \
  --resource-group <ResourceGroupName> \
  --resource <ResourceName> \
  --resource-type <ResourceType>
```

**Example for a Virtual Machine:**

```bash
az lock create \
  --name MyVMLockDelete \
  --lock-type CanNotDelete \
  --resource-group MyResourceGroup \
  --resource MyVM \
  --resource-type Microsoft.Compute/virtualMachines
```

### Using Azure PowerShell

```powershell
New-AzResourceLock -LockName "<LockName>" `
  -LockLevel CanNotDelete `
  -ResourceGroupName "<ResourceGroupName>" `
  -ResourceName "<ResourceName>" `
  -ResourceType "<ResourceType>" -Force
```

**Example for a Virtual Machine:**

```powershell
New-AzResourceLock -LockName "MyVMLockDelete" `
  -LockLevel CanNotDelete `
  -ResourceGroupName "MyResourceGroup" `
  -ResourceName "MyVM" `
  -ResourceType "Microsoft.Compute/virtualMachines" -Force
```

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

### Using Azure CLI

```bash
az lock create \
  --name <LockName> \
  --lock-type ReadOnly \
  --resource-group <ResourceGroupName> \
  --resource <ResourceName> \
  --resource-type <ResourceType>
```

**Example for a Resource Group (all resources within it will be read-only):**

```bash
az lock create \
  --name MyRGReadOnlyLock \
  --lock-type ReadOnly \
  --resource-group MyResourceGroup
```

### Using Azure PowerShell

```powershell
New-AzResourceLock -LockName "<LockName>" `
  -LockLevel ReadOnly `
  -ResourceGroupName "<ResourceGroupName>" `
  -ResourceName "<ResourceName>" `
  -ResourceType "<ResourceType>" -Force
```

**Example for a Virtual Machine:**

```powershell
New-AzResourceLock -LockName "MyVMLockReadOnly" `
  -LockLevel ReadOnly `
  -ResourceGroupName "MyResourceGroup" `
  -ResourceName "MyVM" `
  -ResourceType "Microsoft.Compute/virtualMachines" -Force
```

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

This mechanism ensures that critical virtual machines, which often host essential applications or data, are protected from accidental or unauthorized removal. Remember that a "Read-Only" lock on a VM would prevent both deletion and modification (e.g., stopping, starting, resizing) of the VM through the Azure control plane.
