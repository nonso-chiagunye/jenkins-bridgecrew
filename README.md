<!DOCTYPE html>
<html>
<head>
 
</head>
<body>

# BridgeCrew Jenkins CI/CD Integration for IaC Security

## Prerequisites:

- Jenkins Server running Terraform and Docker
- GitHub Account
- BridgeCrew Account

**NB**: Ensure docker is accessible by the user jenkins. You can check by running the command; <br>
>> `$ id jenkins` <br>

Expect a response like; ***uid=992(jenkins) gid=992(jenkins) groups=992(jenkins),991(docker)***

If not, run the command <br>
>> `$ sudo usermod -aG docker jenkins`

Restart Jenkins; <br>
>> `$ sudo systemctl restart jenkins`

## Configuration Steps:

## 1. GitHub WebHook

First, ensure the jenkins server is accessible from the internet. In my 'configuration', jenkins is behind a firewall while I used load balancer to listen for traffic from the internet. 

Login to GitHub -> select the repo for the project -> click Settings -> Webhook -> Add Webhook. <br>
**Url**: < your_jenkins_url >:< port >/github-webhook/ <br>
**Content type**: application/json <br>
**Events**: Let me select individual events. Select Pull Requests, Pushes. <br>
Add webhook

## 2a. BridgeCrew GitHub Integration

Login to BridgeCrew -> Integrations -> Add Integration -> GitHub -> Authorize (2FA). <br>
Under repositary acces: choose select repository (select your project repo). 

## 2b. BridgeCrew Jenkins Integration

Login to BridgeCrew -> Integrations -> Add Integration -> Jenkins. <br>
Choose subscription type and paste your project repo url. <br>
Ensure you copy the *bc_api_key* generated. You will need this to setup the jenkins pipeline. <br>

## 3a. Jenkins Pipeline: BridgeCrew

***Install Docker Pipeline and Terraform Plugin*** <br>
Dashboard -> Manage Jenkins -> Plugins -> Available Plugins -> Search available plugins -> Install

***Create New Jenkins Pipeline*** <br>
Dashboard -> New Item -> type project name -> pipeline -> Ok

For ***Build Trigers***; <br>
*--GitHub hook trigger for GITScm polling* (If your jenkins server is accessible over the internet) or <br>
*--Poll SCM* and schedule for a time of your choice

For ***Pipeline script***; <br>
Follow the link below for guide. <br>
https://www.checkov.io/4.Integrations/Jenkins.html

Remember to replace the example github url with your project repo url, and use your actual branch name. <br> 
See my *jenkinsfile* for detailed configuration. 

BridgeCrew responds to security misconfiguration with different options. You can set any of the below flags depending on your specific requirement; <br>
**--hard-fail**: This is the default (You don't realy need to set a flag for it). The pipeline brakes for any misconfiguration encountered <br>
**-- soft-fail**: Nothing brakes. It notifies of the security misconfiguration <br>
**--soft-fail-on** < severity > <br>
**--hard-fail-on** < severity >

Severity can be **LOW**, **MEDIUM**, or **HIGH**. 

**Example: --hard-fail-on HIGH Severity**
>> *sh 'checkov -d . --bc-api-key $BC_API_KEY --use-enforcement-rules --hard-fail-on HIGH -o cli -o junitxml --output-file-path console,results.xml --repo-id < github_username >/ <repo_name> --branch < branch_name >'*

For ***environment***; <br>
Setup environment variable for the *bc_api_key* copied in step 2b <br>
Dashboard -> Manage Jenkins -> Credentials -> System(global) -> Add Credentials. <br>

In the space provided, add the following; <br>
**Kind**: Secret Text <br>
**Secret**: the api key copied in step 2b <br>
**ID**: *bc-api-key*

## 3b. Jenkins Pipeline: Terraform

***Configure Terraform Action Parameters*** (Not necessary if you only want to run *terraform apply*) <br>

Dashboard -> Your Project -> Configure -> This project is parameterized. <br>
**Name**: < parameter_name > <br>
**Choices**: apply, destroy, refresh, validate etc <br>
Save

***Complete the Pipeline Stages*** <br>
Include the remaining terraform commands that will run if the BridgeCrew scan returns success <br>
See my *jenkinsfile* for guide <br>
Apply and Save

Go back to the pipeline and click 'Build with Parameters'. Select one out of the parameter *Choices* above <br>

*On Pushes and Pull Requests, the first action specified will run automatically*

</body>
</html>