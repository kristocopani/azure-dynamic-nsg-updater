# Azure NSG Rule Dynamic IP Updater

## Description
Docker image used to dynamically update the IP of a Network Security Group rule on Azure.


## Features
- Update one ip rule on the specified network security group.
- Customize the time intervals

## Under the hood

### Container
- Uses [Alpine Linux:3.14.8](https://hub.docker.com/layers/library/alpine/3.14.8/images/sha256-92d13cc58a46e012300ef49924edc56de5642ada25c9a457dce4a6db59892650?context=explore)
- Uses [PowerShell 7.3.1 for Linux](https://learn.microsoft.com/en-us/powershell/scripting/install/install-alpine?view=powershell-7.3) 
- Automatically installs [Az.Network](https://learn.microsoft.com/en-us/powershell/module/az.network/?view=azps-9.3.0) and [Az.Accounts](https://learn.microsoft.com/en-us/powershell/module/az.accounts/?view=azps-9.3.0) modules for PowerShell from the [Install Modules](/src/installmodules.ps1) script on build
- Uses [dcron](https://pkgs.alpinelinux.org/package/edge/community/x86/dcron)

### PowerShell Script

The scripts does two things as of now:

1. Fetches the current external IP
2. Compares it to the rule on your Azure Network Security Group
3. If the current external IP is different than the defined IP of the rule, it updates it 

## Azure

1. [Create a new Enterprise Application in your Azure AD Tenant](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#register-an-application-with-azure-ad-and-create-a-service-principal) 
2. [Assign the Network Contributor to the Application](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#assign-a-role-to-the-application)
3. [Create a self-signed certificate in the .cer format](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-self-signed-certificate#create-and-export-your-public-certificate)
4. [Export the self-signed certificate](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-self-signed-certificate#optional-export-your-public-certificate-with-its-private-key)
5. [Upload the exported .cer certificate to the application you created earlier on your tenant](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-self-signed-certificate#optional-export-your-public-certificate-with-its-private-key) - ***See the "To upload the certificate" section***


## Usage
1. Start by downloading the repo

```
git clone https://github.com/libgit2/libgit2
cd dynamic-nsg-updater
```

2. Rename the *docker-compose-example.yml* to *docker-compose.yml*
3. Edit the variables found on the *docker-compose.yml* file.
4. Copy the [exported certificate](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-self-signed-certificate#optional-export-your-public-certificate-with-its-private-key) to scripts folder
5. Rename the exported certificate to "certificate.pfx"
6. Then run with

```
docker compose up -d
```


## License

GNU General Public License v3.0



## TODO
- PowerShell script cleanup
- Create log file with IP changes with date
- Allow for custom certificate name
- Put script inside build
- Multiple rules to update
- Multiple NSGs to update 
