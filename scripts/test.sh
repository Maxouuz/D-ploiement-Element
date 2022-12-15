#!/bin/bash

if [ -z "$SSH_AUTH_SOCK" ] ; then
      eval `ssh-agent -s` > /dev/null
      ssh-add $HOME/.ssh/id_rsa.pub > /dev/null 2>&1
   fi
