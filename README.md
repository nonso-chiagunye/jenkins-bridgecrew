<!DOCTYPE html>
<html>
<head>
 
</head>
<body>

# BridgeCrew Jenkins-Pipeline Integration for IaC Scanning

Prerequisites:

- Jenkins Server running Terraform and Docker
- GitHub Account
- BridgeCrew Account

NB: Ensure docker is accessible by the user jenkins. You can check by running the command;\n
<head>$ id jenkins</head>

Expect a response like; uid=992(jenkins) gid=992(jenkins) groups=992(jenkins),991(docker)

If not, run the command

$ sudo usermod -aG docker jenkins

Restart Jenkins

$ sudo systemctl restart jenkins

Configuration Steps:

1. GitHub WebHook

First, ensure the jenkins server is accessible from the internet. In my 'configuration', jenkins is behind a firewall while I used load balancer to listen for traffic from the internet. 

Login to GitHub, select the repo for the project, click Settings -> Webhook -> Add Webhook. 

Url: <your_jenkins_url>:<port>/github-webhook/

Content type: application/json

Events: Let me select individual events. Select Pull Requests, Pushes. 

Add webhook

2a. BridgeCrew GitHub Integration

Login to BridgeCrew, select Integrations, Add Integration, GitHub, Authorize (2FA).

Under repositary acces: choose select repository (select your project repo). 


2b. BridgeCrew Jenkins Integration

Integrations, Add Integration, Jenkins, choose subscription type, paste your project repo url. 

Ensure you copy the bc_api_key generated. You will need this to setup the jenkins pipeline.

3a. Jenkins Pipeline: BridgeCrew

In jenkins, create a new pipeline project (New Item -> type project name -> pipeline -> Ok). 

Next, setup environment variable for the api_key copied in step 2b

Manage Jenkins -> Credentials -> System(global) -> Add Credentials. 

In the space provided, add the following;

Type: Secret Text

Secret: the api key copied in step 2b

ID: bc-api-key

Go down to the pipeline script space, follow the link below for guide on creating the pipeline stages.

https://www.checkov.io/4.Integrations/Jenkins.html

Remember to replace the example github url with your project repo url, and at other necessary places. You can check my jenkinsfile for detailed configuration. 

You can configure BridgeCrew to take different action when it encounters a security misconfiguration

--hard-fail: This is the default. The pipeline brakes for any misconfiguration encountered

-- soft-fail: Nothing brakes. It notifies of the security misconfiguration

--soft-fail-on <severity>

--hard-fail-on <severity>

severity can be LOW, MEDIUM, HIGH or CRITICAL. 

3b. Jenkins Pipeline: Terraform

I started with init as the next stage after BridgeCrew scan. You can check my jenkinsfile for detailed script. 

You can hard-code 'apply' in your final stage if you only want to apply with the pipeline. I parameterized because I wanted to use same pipeline for apply and destroy. So I used variable 'action' to represent both. You can add the parameters as follows;

Click on your pipeline -> Configure -> This project is parameterized.

Name: action

Choices: apply, destroy

Save

Go back to the pipeline and click 'Build with Parameters'.

</body>
</html>