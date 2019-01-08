#!/bin/bash
ssh jumphost@fairy_tales.com '/usr/sbin/sendmail treasurer@fairy_tales.com' < <(
echo 'From: Dwarf <noreply@fairy_tales.com>'
echo "Subject: $(hostname) status report"
echo
free
echo
df -lh
echo
docker --version
echo
docker container list --all
echo
docker image ls --all
echo
docker volume ls
)
