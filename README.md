# Restore removed /bin

## Introduction
This script will restore the accidentally or on purpose removed /bin directory.

It uses `dpkg` and `apt` utilities, so it's only works on Debian, Ubuntu or distributions based on them, although you can simply modify it to get it work with other package managers.

It's able of download, extract and move only necessary files into `/bin` to fix the issue, or reinstall all related packages to get the job done.

- - -

## Usage

A compelete guide has been posted [here](https://askubuntu.com/a/906675/264781) at AskUbuntu, which describes how to `chroot` and use script to fix the issue.

You shoud first `chroot` into your broken system. Then simply run the script, it will create a list of all packages which has any file in /bin directory and lists their files for you.

![restore /bin](https://raw.githubusercontent.com/ravexina/restore-bin/master/screenshots/list.png)

After all it asks you what should it do to fix the issue? you can reinstal all related packages or download and extract the neccessary files to `/bin`, make your choise and it's done.

![restore removed /bin](https://raw.githubusercontent.com/ravexina/restore-bin/master/screenshots/question.png)
