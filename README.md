# Test Ubuntu 17.10.1 using openQA

[openQA] is an automated test tool for operating systems and the engine
at the heart of openSUSE's automated testing initiative. This is an
independent project created for demo and teaching purposes of openQA
to the Ubuntu world.

See our [live demo].

----

## 1. Run openQA container

**Note**: You need docker running and working properly!

Run the following bash script, which will start openQA.
In case you have a webserver running at 80 or 443, just
change the variable in the scripts into anothe port.

```bash
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


## 2. Pull the tests and the assets

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

## 3. Create the testing-plan

Although you can do this via the web interface, it's easier to use
a script to dump the template over there:

```bash
# docker exec -it generic-openqa_worker /usr/share/openqa/script/load_templates --host http://openqa-webui /var/lib/openqa/tests/ubuntu/templates
```

Expected output, similar to this:

```bash
{
  JobTemplates => { added => 3, of => 3 },
  Machines     => { added => 1, of => 1 },
  Products     => { added => 1, of => 1 },
  TestSuites   => { added => 3, of => 3 },
}
```

To make sure that everything went smooth, you can open Firefox and browse
the dashboard:

```bash
$ firefox http://$HOSTNAME/admin/{products,machines,test_suites,groups}
```

## 4. Start testing

Use the `openqa-client` utility which is installed into our
openqa-worker container to schedule the tests:

```bash
docker exec generic-openqa_worker openqa-client --host http://openqa-webui isos post DISTRI=ubuntu VERSION=17.10 FLAVOR=desktop ARCH=amd64
```

Then open Firefox and go to the web interface to monitor
the results.



[live demo]: https://youtube.com
[openQA]: http://open.qa/
