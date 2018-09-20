<meta name="google-site-verification" content="NgRYO89lF4vkaY21HqkY7uNjtIlhshShPRvD7i2VKC4" />

# Vagrant

* Website: [https://www.vagrantup.com/](https://www.vagrantup.com/)
* VirtualBox: [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
* Source : [https://github.com/pprashanth/Vagrant](https://github.com/pprashanth/Vagrant)


Vagrant is a tool for building and distributing development environments.

Development environments managed by Vagrant can run on local virtualized
platforms such as VirtualBox or VMware, in the cloud via AWS or OpenStack,
or in containers such as with Docker or raw LXC.

Vagrant provides the framework and configuration format to create and
manage complete portable development environments. These development
environments can live on your computer or in the cloud, and are portable
between Windows, Mac OS X, and Linux.



## Quick Start

For the quick-start, we'll bring up a development machine on
[VirtualBox](https://www.virtualbox.org/) because it is free and works
on all major platforms.
First, make sure your development machine has
[VirtualBox](https://www.virtualbox.org/)
installed. After this,
[download and install the appropriate Vagrant package for your OS](https://www.vagrantup.com/downloads.html).

To build your first virtual environment:

Clone the git repo [https://github.com/pprashanth/Vagrant](https://github.com/pprashanth/Vagrant) .
Go to the cloned repo directory .You will find two files ,

  1.vagrant - This is  a simple vagrant file which spins up Virtual boxes for you .
  2.OS.sh -  This shell script runs on Virtual boxes and install required packages for you.Modify this script incase you need additioanl packages.

 Vagrant file have two modes ,

  1.Manual mode : - This mode will setup two virtual boxes for you .By default vagrant will setup one manager and one worker node for you .

```bash
    vagrant up
    Vagrant status
```

  2.Auto Mode  : - This mode will setup two virtual boxes's with pre-configured Docker Swarm for you.(Manger + 1 worker node).If you would like to  have more worker nodes modify the below parameters in vagrant file and 'Auto=true vagrant up '

```bash
    AUTO=true vagrant up
    Vagrant status      #Shows you the running VM's
```

Note: The above `vagrant up` command will also trigger Vagrant to download the
`centos/7` box via the specified URL. Vagrant only does this if it detects that the box doesn't already exist on your system.

#Customize vagrant file

By default vagrant up spins up 2 machines: manager, docker01. You can adjust how many workers you want in the Vagrant file, by setting the numworkers variable. Manager, by default, has address "192.168.10.10", workers have consecutive.

```bash
  numworkers = 1
```

You can modify the vm allocations for memory and cpu by changing these variables:

```bash
  v.memory = 5048
  v.cpu = 2
```
