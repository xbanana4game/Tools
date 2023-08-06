#!/bin/bash

tar cvzf /share/linux/linux_git_`date +%Y%m%d`.tar.gz  -C /share/linux --exclude __old git
