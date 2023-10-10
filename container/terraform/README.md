# release-terraform-integration
It is container based integration for Digital.ai Release 

### Terraform: Apply and Destroy (Container) Task

**Apply task :** It is to execute the Terraform module using the 'apply' command

**Destroy task :** It is to execute the Terraform module using the 'destroy' command

### Task Inputs

The Terraform Apply and Destroy tasks are accepts the following inputs:

1. **Git URL:** The URL of the Git repository containing your Terraform configuration files.
2. **Git branch:** The Git branch to check out from the repository.
3. **Git directory path:** The directory path within the Git repository where your Terraform configuration files are located.
4. **Git Token:** The Git access token used for authentication to access the repository.
5. **Environment Variables:** Additional environment variables that your Terraform configuration may require. Pass terraform environment variables the following format: {'VAR1': 'value1', 'VAR2': 'value2'}

### Task Outputs

**Output Variables:** Return variables and values for a Terraform module

### Task Screenshots

![Apply Task](images/apply.PNG)


![Destroy Task](images/destroy.PNG)
