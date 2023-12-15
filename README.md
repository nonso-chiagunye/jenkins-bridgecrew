<!DOCTYPE html>
<html>
<head>
 
</head>
<body>

# BridgeCrew Jenkins-Pipeline Integration for IaC Scanning

## Prerequisites:

- Jenkins Server running Terraform and Docker
- GitHub Account
- BridgeCrew Account

**NB**: Ensure docker is accessible by the user jenkins. You can check by running the command; <br>
$ id jenkins <br>

Expect a response like; uid=992(jenkins) gid=992(jenkins) groups=992(jenkins),991(docker)

If not, run the command <br>
$ sudo usermod -aG docker jenkins

Restart Jenkins; <br>
$ sudo systemctl restart jenkins

## Configuration Steps:

## 1. GitHub WebHook

First, ensure the jenkins server is accessible from the internet. In my 'configuration', jenkins is behind a firewall while I used load balancer to listen for traffic from the internet. 

Login to GitHub -> select the repo for the project -> click Settings -> Webhook -> Add Webhook. <br>
**Url**: <your_jenkins_url>:<port>/github-webhook/ <br>
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

In jenkins, create a new pipeline project (New Item -> type project name -> pipeline -> Ok). <br>
Next, setup environment variable for the *bc_api_key* copied in step 2b <br>
Manage Jenkins -> Credentials -> System(global) -> Add Credentials. <br>

In the space provided, add the following; <br>
**Type**: Secret Text <br>
**Secret**: the api key copied in step 2b <br>
**ID**: *bc-api-key*

Go down to the pipeline script space, follow the link below for guide on creating the pipeline stages. <br>
https://www.checkov.io/4.Integrations/Jenkins.html

Remember to replace the example github url with your project repo url, and at other necessary places. You can check my jenkinsfile for detailed configuration. 

BridgeCrew takes different action when it encounters a security misconfiguration <br>
**--hard-fail**: This is the default. The pipeline brakes for any misconfiguration encountered <br>
**-- soft-fail**: Nothing brakes. It notifies of the security misconfiguration <br>
**--soft-fail-on** <severity> <br>
**--hard-fail-on** <severity>

Severity can be **LOW**, **MEDIUM**, **HIGH** or **CRITICAL**. 

## 3b. Jenkins Pipeline: Terraform

I started with *terraform init* as the next stage after BridgeCrew scan. See my jenkinsfile for detailed script. 

You may hard-code *terraform apply* in your final stage if you only want to apply with the pipeline. I parameterized because I wanted to use same pipeline for *terraform apply* and *terraform destroy*. So I used placeholder *action* to represent both. To add the parameters;

Click on your pipeline -> Configure -> This project is parameterized. <br>
**Name**: action <br>
**Choices**: apply, destroy <br>
Save

Go back to the pipeline and click 'Build with Parameters'.

</body>
</html>