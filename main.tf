/*
TERRAFORM CLOUD::: Terraform has 2 version:: CE (Community Edition) & EE(Enterprise Edition). CE is nothing but cli & EE is the
console from where terraform can be accessed.

Demerits in CE::
1.No workflow management (Once login you can seewho can apply,run,plan)
2.No state file enhancement/versioning feature.
3.No Policy control. (SENTINEL POLICIES are required) (Policy means what are things recommended & what are not)
4.No Access Control.
5.No multi-user support

Sentinel policy gets executed in:: init-->Plan-->Sentinel --->Apply..Suppose for anything if plan gets even passed,but if we are
not allowed to creat, then sentinel policy will throw an error here.

Terraform portal comes in 2 formats::
1. SAAS based offering (we don't have to manually install)
2. Hosted Edition(Gives the license feature where we can install in the local)

In terraform: Organisation--> Its like project, Workspace--> inside it where we create everything & it has settings with state file
Inside Workspace, there is PRIVATE REGISTRY where MODULES/PROVIDERS  can be published if developed your own software.
Also , there is PUBLIC PROVIDERS(REGISTRY) which itself we search from Browse modules->AWS, then we don't store such resources
in the providers.We have USAGE where limits & policy are defined.Also we have SETTINGS,where we have to generate 
AUTHENTICATION-->API TOKENS through which we can access the CLOUD BLOCK.

There are 3 types we can create the WORKSPACE::
1.CLI-driven workflow:: If in the code, we map the workspace then everything we run(init,plan,apply)or the state file will be 
                        created in the UI console (remotely)
2.VERSION control workflow
3.API-driven workflow

Once I run the coomands from cli, it will automatically open a page to gnerate the API token whose expiration date has to be 
chosen & it will be copied. Ensure to keep it as we will not be able to fetch the code later. Once the API token is generated
we can copy the ORGANISATION & WORKSPACE in the terraform code.Till the time the token is not generated, it will not be able to 
communicate with the workspace.So (plan,run) all commands ,i-e, the terraform workload will be running in the workspace.

S F:\Terraform_Cloud\DAY11_2> terraform login       -->WILL GIVE "TERRAFORM LOGIN 1ST"
Terraform will request an API token for app.terraform.io using your browser.

If login is successful, Terraform will store the token in plain text in
the following file for use by subsequent commands:
    C:\Users\Arijit\AppData\Roaming\terraform.d\credentials.tfrc.json   -->THE TOKEN WILL BE SAVED HERE

Do you want to proceed?
  Only 'yes' will be accepted to confirm.

  Enter a value: yes  ---->WILL TYPE YES & THEN WILL OPEN A PORTAL WHERE EXPIRATION DURATION IS GIVEN TO GENERATE TOKEN


---------------------------------------------------------------------------------

Terraform must now open a web browser to the tokens page for app.terraform.io.

If a browser does not open this automatically, open the following URL to proceed:
    https://app.terraform.io/app/settings/tokens?source=terraform-login


---------------------------------------------------------------------------------

Generate a token using your browser, and copy-paste it into this prompt.

Terraform will store the token in plain text in the following file
for use by subsequent commands:
    C:\Users\Arijit\AppData\Roaming\terraform.d\credentials.tfrc.json

Token for app.terraform.io:
  Enter a value:                                -->PASTE THE TOKEN WHERE IT WILL SHOW INVISIBLE


Retrieved token for user kush-dotcom


---------------------------------------------------------------------------------

                                          -
                                          -----                           -
                                          ---------                      --
                                          ---------  -                -----
                                           ---------  ------        -------
                                             -------  ---------  ----------
                                                ----  ---------- ----------
                                                  --  ---------- ----------
   Welcome to HCP Terraform!                       -  ---------- -------
                                                      ---  ----- ---
   Documentation: terraform.io/docs/cloud             --------   -
                                                      ----------
                                                      ----------
                                                       ---------
                                                           -----
                                                               -


   New to HCP Terraform? Follow these steps to instantly apply an example configuration:

   $ git clone https://github.com/hashicorp/tfc-getting-started.git
   $ cd tfc-getting-started
   $ scripts/setup.sh

I the code (copied from previous Day11_1), we removed the backend s3 part with the "cloud" block as mentioned below.On running the
terraform init, it passes successfully but on running the terraform plan we will see we are getting error as below::

Error: No valid credential sources found
│
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on main.tf line 121, in provider "aws":
│  121: provider "aws" {

It got failed as because the credential we gave its for "local" but here it is required for "cloud". So that credential will be 
set in the VARIABLES like CI/CD.

VARIABLES:: Here we set the variables that is being used in cloud. Now in the workspace-->Add variable we are adding 2 Environment
Variables for authentication with the aws so in terraform  we provided the details of Aws_access key & AWS_Secret_key & saved it.
These variables are added in particular workspace where the user authenticates. Now when we will run terraform plan , we will see
the plan running but everything this times it will load remotely in UI. Go to Runs-->Run ID gets created for every run. In RUNS
we can see whatever errors are even getting generated.

Once planning we checked, we applied the same from cli & checked everything from terraform console in RUNS where each step ran 
& the o/p was visible from there. Once plan & apply is run we can see the above as LOCK (in the RUNS & STATES),i-e, both for 
Workspace & if we lock it, the workspace will be showed as LOCKED STATE. Now if we again do "terraform plan", it will execute it
& the same can be checked in RUNS but when we try to run "terraform apply" , it will not be able to run & in console it will show
as "PENDING" but when checked in cli, it will show the error as :: "Waiting for the manually locked workspace to be unlocked" & 
the prompt will come & till the time we make the WORKSPACE UNLOCK, terraform apply will not be able to work & it will lock it.
To unlock the same, go to console & give UNLOCK WORKSPACE.

REMOTE EXECUTION VS LOCAL EXECUTION::

For REMOTE execution,when the terraform code is run in user machine but the plan,apply runs on terraform cloud & as well as
the state file is stored/run on Terraform cloud. Terrform cloud is called REMOTE MACHINE & user machine is called 
REMOTE EXECUTION. We can see the RUNS here in the WORKSPACE & also the EXECUTION MODE:: REMOTE

USER MACHINE(local machine) -----> TERRAFORM CLOUD(UI/CONSOLE/REMOTE MACHINE)    ------> TARGET MACHINE(AWS/AZURE/GCP)
                                (Credential stored here & when
                                the code is run, the RUNS & STATES
                                provide the o/p in the console.)

For LOCAL execution, while running the code the plan,apply runs in local machine but still the state file is stored in
Remote machine.We can't see the RUNS here in the WORKSPACE & also the EXECUTION MODE:: LOCAL & only the state file is used
& seen here.

USER MACHINE(local machine) -----> TERRAFORM CLOUD(UI/CONSOLE/REMOTE MACHINE)    ------> TARGET MACHINE(AWS/AZURE/GCP)
(Credential stored here & plan      (STATE file is stored & seen here in terr
apply is run here)                   aform UI/console)

If we want we can also CHANGE THE EXECUTION MODE from REMOTE TO LOCAL. Once changed to local, we will the RUNS option will get
disappear from the UI(cloud). Go to the WORKSPACE overview -->Right hand side -->Execution mode where we can change & then save
settings. In ENTERPRISE level, we always prefer to use REMOTE EXECUTION as then in the RUNS (plan,apply)will be visible & also
in STATES(terraform state file) will also be visibile from Terraform cloud(UI/console)


                                


PS F:\Terraform_Cloud\DAY11_2> 
*/



terraform {
  cloud {

    organization = "arilabcloud"

    workspaces {
      name = "arilabcli"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1" //Here the resources will get created
}

data "aws_ami" "this" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_vpc" "this" {
  default = true
}

locals { //Both ingress & egress are defined in locals
  ports = {
    ssh = {
      direction = "ingress" //Taking this as string as we need to print it
      f_port    = 22
      protocol  = "tcp"
      cidr      = "192.168.29.86/32"
    }
    http = {
      direction = "ingress"
      f_port    = 80
      protocol  = "-1"
      cidr      = "0.0.0.0/0"
    }
    https = {
      direction = "ingress"
      f_port    = 443
      protocol  = "tcp"
      cidr      = "0.0.0.0/0"
    }
    all = {
      direction = "egress"
      f_port    = 0
      to_port   = 65535
      protocol  = "-1"
      cidr      = "0.0.0.0/0"
    }
  }
}

resource "aws_security_group" "main" {
  name   = "mysg"
  vpc_id = data.aws_vpc.this.id
}

resource "aws_security_group_rule" "main" {
  for_each          = local.ports //Using for_each calling the direction & printing the port,protocol,cidr seperately
  type              = each.value.direction
  from_port         = each.value.f_port
  to_port           = each.value.f_port
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr] //It will always come in LIST
  security_group_id = aws_security_group.main.id
}

resource "aws_key_pair" "sre" {
  key_name   = "mykey"
  public_key = file("./.ssh/aws.pub")
}

resource "aws_instance" "this" {
  ami             = data.aws_ami.this.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.sre.key_name
  security_groups = [aws_security_group.main.name]

  provisioner "remote-exec" { //List of strings.Multiple commands can be used
    inline = [
      "mkdir /home/ubuntu/ari",
      "echo 'hello' >> /home/ubuntu/ari/ari.txt"
    ]
  }
  /*provisioner "file" {
    source      = "./publicip.txt"
    destination = "/home/ubuntu/publicip.txt"
  }
  */
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./.ssh/aws") // Use the private key here but not the aws.pub one
    host        = self.public_ip
  }

}
// We will see the publicip.txt file which is created in the left side of DAY11
output "public_ip" {
  value = aws_instance.this.public_ip
}
