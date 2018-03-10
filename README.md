# Test Ubuntu 17.10.1 using openQA

## Run openQA container

**Note**: You need docker.

Run the following bash script, which will start openQA.
In case you have a webserver running at 80 or 443, just
change the variable in the scripts into anothe port.

```
#!/bin/bash

user="generic"
webport="80"
rsyncport="873"
sslport="443"

# Start the openQA Web Interface
docker run -d --name $user-openqa_webui \
    -p $webport:80 -p $rsyncport:873 -p $sslport:443 \
    -v $user-Assets:/var/lib/openqa/share/factory -v $user-Tests:/var/lib/openqa/share/tests \
    binarysequence/openqa-webui

# Generate fake key authentication
sleep 5; curl -X POST http://localhost:$webport/login

# Start one worker
docker run -d --privileged --name $user-openqa_worker \
              --link $user-openqa_webui:openqa-webui \
              --volumes-from $user-openqa_webui \
              binarysequence/openqa-worker-x86_64
```

Now go to `http://localhost:80` and login (fake authentication).
This is the openQA web interface. Make sure that your worker
seems to be online.


## Pull the tests and the assets

The two docker containers have created two directories:

```bash
# ls -l /var/lib/docker/volumes
total 24
drwxr-xr-x 1 root root    10 Mar  7 16:36 generic-Assets
drwxr-xr-x 1 root root    10 Mar  7 16:36 generic-Tests
```

Both of them, they contain a sub-directory called `_data`
which gets created by default thanks to Docker. In this
way, Docker shares those *volumes* among its containers
and the host operating system.


### Clone the tests

Go into `generic-Tests/_data/` and create a folder called `ubuntu`.
Then go inside that folder and clonde this repository:

```bash
localhost:/var/lib/docker/volumes # cd generic-Tests/_data/ubuntu/
localhost:/var/lib/docker/volumes/generic-Tests/_data/ubuntu # git clone https://github.com/drpaneas/ubuntu_qa
```

### Download Ubuntu

Go to [URL](https://www.ubuntu.com/desktop/1710) and download
the ISO for **Ubuntu 17.10**. Then *move* the file into the
**assets** directory, and place it under the **iso** folder:

```bash
mv /home/drpaneas/Downloads/ubuntu-17.10.1-desktop-amd64.iso /var/lib/docker/volumes/generic-Assets/_data/iso
```

### Fix permissions

In order for the Docker container to be able to create *new needles*
we need to make sure that the directory has the correct ownership:

```bash
# cd /var/lib/docker/volumes/generic-Tests/_data/ubuntu/products/ubuntu
# chown -R 496:nogroup needles/
```

Then, let's make sure that our openqa-worker can save logs, videos,
qcow2 images and other assets. To do this, just give everything
for free *because I don't remember the correct permissions atm*:

```bash
# cd /var/lib/docker/volumes/generic-Assets
# chmod -R 777 _data/
```

## Manage the web interface

### Create medium

Open your browser and go to the openQA web-interface.

Click at **Logged in as Demo** and this pop-up a menu of options.
Choose **Medium types**. Then click at **New Medium**.

```bash
 =========================================================================
| Distri | Version | Flavor | Arch | Settings                             |
|--------|---------|--------|------| -------------------------------------|
| ubuntu | 17.10   | desktop| amd64| ISO=ubuntu-17.10.1-desktop-amd64.iso |
 =========================================================================
```

### Create machine

Click at **Logged in as Demo** and this pop-up a menu of options.
Choose **Machines**. Then click at **New Machine**

```
Name: 64bit
Backend: qemu
```

Settings:

```
CDMODEL=ide-cd
HDDSIZEGB=25
QEMUCPU=Haswell-noTSX
QEMUCPUS=1
QEMURAM=2048
QEMUVGA=qxl
WORKER_CLASS=qemu_x86_64
```

### Create Testsuite

Click at **Logged in as Demo** and this pop-up a menu of options.
Choose **Testsuites**. Then click at **New Testsuite** and create
**3** of them:

*Name*: desktop_live

Settings:
```
INSTALL_TYPE=try
```

*Name*: desktop_installation

Settings:
```
INSTALL_TYPE=install
PUBLISH_HDD_1=ubuntu.qcow2
QEMU_COMPRESS_QCOW2=1
```

*Name*: gnome_tests

Settings:
```
BOOT_HDD_IMAGE=1
HDD_1=ubuntu.qcow2
START_AFTER_TEST=desktop_installation
TEST_TYPE=GUI
```

### Create Job Groups

Click at **Logged in as Demo** and this pop-up a menu of options.
Choose **Job Groups**. Then click at **+** symbol to add a new.

```
Add folder: Ubuntu
Sub name: Ubuntu 17.10
```

Click on **Ubuntu 17.10** job group and then click at
**Test new medium as part of this group**. Create **3** of them:

```
Medium: ubuntu-17.10-desktop-amd64
Testsuite: desktop_installation
Machine: 64bit
```
```
Medium: ubuntu-17.10-desktop-amd64
Testsuite: gnome_tests
Machine: 64bit
```
```
Medium: ubuntu-17.10-desktop-amd64
Testsuite: desktop_live
Machine: 64bit
```

## Run the tests

Use the `openqa-client` utility which is installed into our
openqa-worker container:

```bash
docker exec generic-openqa_worker openqa-client --host http://openqa-webui isos post DISTRI=ubuntu VERSION=17.10 FLAVOR=desktop ARCH=amd64
```

Then open Firefox and go to the web interface
to monitor the results.




Have fun,
Panos
