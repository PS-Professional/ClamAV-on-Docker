ClamAV installer on Docker engine

Developed by PS-Professional

     ____  ____        ____             __               _                   _ 
    |  _ \/ ___|      |  _ \ _ __ ___  / _| ___  ___ ___(_) ___  _ __   __ _| |
    | |_) \___ \ _____| |_) | '__/ _ \| |_ / _ \/ __/ __| |/ _ \| '_ \ / _` | |
    |  __/ ___) |_____|  __/| | | (_) |  _|  __/\__ \__ \ | (_) | | | | (_| | |
    |_|   |____/      |_|   |_|  \___/|_|  \___||___/___/_|\___/|_| |_|\__,_|_|


## What is ClamAV?

ClamAV is a command-line anti-virus which can scan your files by you command-line input or automatic scanning schedule. ClamAV can detect over 1 million viruses, worms and trojants, including Microsoft Office macro viruses, mobile malwares and other threats. For more information, visit [ClamAV documentation](https://clamav.net/document/introduction) on thier website.

## What will this project do?

This project will dockerize and setup ClamAV as a online anti-virus scanner and you can use this project to scan your localhost, webserer and other files online. As first step, all you need to do is run the run.sh script file. This script has six functions:
* init 

* start

* control

* restart

* stop

* exit

This script first check your host if Docker exists or not when you use `init` function. If you had installed Docker before, it will ask you for updating system or not and if you didn't installed docker before, it will start installing Docker on yuor host. After that Docker will start getting required files and make them ready for setting containers up. When init function done, you will back to your prompt. Then run the script agian and use `start` function to start ClamAV container. After service creation, you can scan your files online(We will describe it later). You can control ClamAV container using `control` option. If needed, you can restart containers using `restart` function and to shut it down, just use `stop` function. Finally, to exit from script just use `exit` function.

## How to scan my files?

To scan your desired files, first you should check if `clamdscan` package is installed on your distribution or not. If it is not available, you can simply installing it using your distribution's package manager, for example: `sudo apt install clamdscan`. After that, you need to modify clamdscan config file which is `/etc/clamav/clamd.conf` in order to send your files to a remote host instead of scanning them locally (If file is not present, run `clamd` command to create configuration file). In this file, you can see some directives ClamAV generated them by default, but some of them should be modified. First, find `TCPAddr` and `TCPSocket` directives (If you didn't find them, don't worry. Add them yourself! :) ) and set `TCPAddr` to your `remote IP address` and set `TCPSocket` to `3310` (THe port is default acording to ClamAV documentation). To scan your files, use `clamdscan -v -m /path/to/files`. This should work but if something went wrong, first check yor remote server if its firewall is active and allow data transmision throughout port 3310. To check this, for example on Ubuntu server, use `sudo ufw status` command. If firewall disabled, you need to change some settings on your local which described later in this section, but if firewall status is active, then check if this port is allowed or not. If this port is not in list or connections denied, use `sudo ufw allow 3310` to allow connection to this port on remote server. But if you face problems again, you need to modify more ClamAV directives on `/etc/clamav/clamd.conf` file. There are some directives for ClamAV which use local Unix socket to scan your file locally. To avoid this happen, you need to comment `LocalSocket`, `FixStaleSocket`, `LocalSocketGroup` and `LocalSocketMode` directives. That should make it works.

## My experience on this project

I used ClamAV locally on my system and I decided to make it Server/Client base instead of a local software only. First, I noticed that to perform this task, you need to use `clamdscan` instead of `clamscan` command. For server side, I used ubuntu image and installed ClamAV packages and started configuring it as a server service. After many tries I done with ClamAV, I almost set it up and send some of my files to scan it and send me result.