# Azure DevOps Pipeline Configuration

This repository contains templates and variable files for configuring Azure DevOps pipelines. The templates are designed to streamline the build and deployment processes for various projects.

## Repository Structure

- **Projects/templates/**: Contains YAML templates for build and deployment stages.
- **Projects/Variables/dairy_breeding_genetics/**: Contains variable files for different environments.

## Using the Templates

### Prerequisites

1. Ensure you have the necessary service connections set up in your Azure DevOps project.
2. Verify that the variable files and templates are correctly referenced in your pipeline YAML.

### Pipeline Configuration

To use the templates and variables in your pipeline, include the following in your pipeline YAML file:

```yaml
resources:
  repositories: 
    - repository: AzurePipelineTemplates
      type: git
      name: adb.DevOps.Tasks.Projects/AzurePipelineTemplates
      ref: refs/heads/main

trigger:
  branches:
    include:
      - Development
      - Release

pr:
  branches:
    include:
      - Release

name: $(SourceBranchName)_$(environment)_$(Build.BuildId)_$(date:yyyyMMdd)$(rev:.r)

variables:
  - template: Projects/Variables/dairy_breeding_genetics/table-manager-dev.yml@AzurePipelineTemplates

stages:
- template: Projects/templates/build-template.yml@AzurePipelineTemplates
  parameters:
    stageName: Build

- template: Projects/templates/deploy-template.yml@AzurePipelineTemplates
  parameters:
    stageName: DeployToDev
    dependsOn: Build
    azureServiceConnection: $(azureServiceConnection)
    WebAppName: $(WebAppNameDev)
    environment: 'Development'
    vmImageName: $(vmImageName)

- template: Projects/templates/deploy-template.yml@AzurePipelineTemplates
  parameters:
    stageName: DeployToProd
    dependsOn: DeployToDev
    azureServiceConnection: $(azureServiceConnection)
    WebAppName: $(WebAppNameProd)
    environment: 'Production'
    vmImageName: $(vmImageName)

Variables:
The variable file table-manager-dev.yml contains the following variables:

variables:
  azureServiceConnection: 'Enterprise Dev/Test(6265bce6-d9a1-412b-b2c9-565a7d6880a7)'
  WebAppNameDev: 'RLVarietySelectTool-Dev'
  WebAppNameProd: 'RLVarietySelectTool-Prod'
  vmImageName: 'windows-latest'

Security:
To avoid exposing sensitive information, use Azure DevOps variable groups and mark sensitive variables as secret.

Contributing
Feel free to contribute to this repository by submitting pull requests. Ensure that your changes are well-documented and tested.