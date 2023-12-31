# Terraform Beginner Bootcamp 2023 


## Semantic versioning :mage:

This project is going to utilize semantic versioning or it's tagging.
[semver.org]https://semver.org/

The general format:

**MAJOR.MINOR.PATCH**, e.g `1.0.1`

- ***MAJOR*** version when you make incompatible API changes
- ***MINOR*** version when you add functionality in a backward compatible manner
- ***PATCH*** version when you make backward compatible bug fixes
Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

## Install the Terraform CLI

## Considerations with the Terraform CLI changes

The Terraform CLI installations have changed due to gpg keyring changes. So we needed to refer to the latest install CLI instructions 
via Terraform Documentation and change the script for install

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Consideration for linux distribution

This project is built against Ubuntu.
Please consider checking your linux distribution and change according to distribution needs.

[How To Check OS Version in Linux ](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version:
```
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```


### Refactoring into Bash scripts

While fixing the Terraform CLI gpg depreciation  issue we notice that the bash scripts steps were considerable amount more code. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod task file ([.gitpod.yml](.gitpod.yml)) tidy.
- This allow us an easier to debug and execute manually Terraform CLI install 
- This will allow better portability for projects that need to install Terraform CLI.

#### Shebang considerations

A shebang (pronounced sha-bang) tells the bash script what interpreter program that will interpret the script. eg. `#!/bin bash`

3-refactor-terraform-cli
https://en.wikipedia.org/wiki/Shebang_(Unix)

ChatGPT recomended we use this format for bash: `#!/usr/bin/env bash`

- For portability for different OS distriutions
- Will search the user's PATH for the bash executions

#### Execution Considerations
When executing bash scripts we can use the `./` shorthand notataion to execute

eg, `./bin/install_terraform_cli`


#### Linux Considerations

In order to make our bash scripts executable we need to change linux permissions for the file to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

Alternatively:
```sh
chmod 744 ./bin/install_terraform_cli
```
https://en.wikipedia.org/wiki/Chmod


### Gitpod lifecycle

We need to be careful when running the init because it will not re-run if we restart in an existing workspace.


https://www.gitpod.io/docs/configure/workspaces/tasks

### Working with Env Vars

We can list all E   nvironmental variales (Env Vars) using the `env` command

We can filter specific env vars using grep eg. `env | grep AWS_`

### Setting and unsetting Env Vars
In the terminal we can set using `export HELLO='world'`

In the terminal we can unset using `unset HELLO`

We can set an env temporarily when running a command

```sh
HELLO='world' ./bin/print_message
```

In a bash script we can set an env without writing export

```sh
#!/usr/bin/env bash
HELLO='world'

echo $HELLO
```

#### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

#### Scoping of Env Vars

When you open a new bash terminal in VScode it wil not be aware of env vars thst you have set in another window.

If you want to persist across all future bash terminals that are open you need to set env vars in your bas profile. eg. `.bash_profile`

```
gp envv HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in tose workspaces.

### AWS CLI installation

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS environment is set up correctly using 

```sh
aws sts get-caller-identity
```

If it is sucessful you should see a json payload return that looks like this:

```json
{
    "UserId": "AIDAWSR6HEZNDER4TYARDX",
    "Account": "647373383737",
    "Arn": "arn:aws:iam::647373383737:user/terraform-beginner-bootcamp"
}
```

We'll need to create an IAM user and generate AWS CLI credentials.

## Terraform Basics

## Terraform Registry

TTerraform sources their providers and modules form the Terraform registry which is loacated at registry [terrafrom.io](https://registry.terraform.io)

- **Providers** are interfaces to API's that allow you to create resources in terraform
- **Modules** are a way to make large amount of terraform code modular, portable and sharable.


[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

#### Terraform console

We can see the list of all terraform commands by typing `terraform`

##### Terraform init

At the start of a new terraform project we will run `terraform init` to initialize the backend, download and install providers plugins we will use in this project.

#### Terraform Plan

This will generate a change set about our infrastructure and what will be changed.

We can out put this changeset ie. `plan` to be passed to an apply, but often you can just ignore outputing.

#### Terraform Apply 

`terraform apply`

This will run a plan and pass the changeset to be executed by terraform. Apply should prompt us yes or no.

If we want to automatically apply we can provide the auto approve flag eg. `terraform apply -auto-approve`

#### Issues
Ran into an error while creating an S3 bucket rffred to the documentation and find out that your s3 bucket name must only contain lowercaseses and must not begin nor end with a letter
[S3 Naming Rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)

#### Terraform Destroy
This will destroy resources .
You can also use the auto approve plan lag to skip the approve prompt
eg. `terraform destroy --auto-aprove`

#### Terraform Lock files
`.terraform.lock.hcl` contains the locked versions for the providers or modules that should be used wit this project.

The terraform lock file **should be committed** to your version control system (VCS) eg. GitHub

#### Terraform State file

`.terraform.tfstate` contains information about the current state of your infrastructure. this file **should NOT be committed** to your version control system.

This file can contain sensitive data 

If you lose this file you lose knowing th =e state of your infrastructure

`.terraform.tfstate.backup` id the previous state file.

#### Directory
`.terraform` dirctory cntains a local cache where Terraform retains some files it will need for subsequent operations against this configuration. 

## Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terraform login` it will launch bash a wiswig view to generate a token. However it does not work as epected in in Gitpod VsCode in the browser.

The workaround is manually generated a tokent in Terraform Cloud


```
https://app.terraform.io/app/settings/tokens
```

Then create the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file)


```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```

Then open the file




