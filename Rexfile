
# -- Initial Setup
# add wheel to sudoers
# download and verify ports
#$ cd /tmp
#$ ftp http://ftp.openbsd.org/pub/OpenBSD/5.5/ports.tar.gz
#$ ftp http://ftp.openbsd.org/pub/OpenBSD/5.5/SHA256.sig
#$ signify -C -p /etc/signify/openbsd-55-base.pub -x SHA256.sig ports.tar.gz
#$ cd /usr
#$ sudo tar xzf /tmp/ports.tar.gz
# create /etc/mk.conf
## SUDO=/usr/bin/sudo -E
## USE_SYSTRACE=yes
#$ chgrp -R wsrc /usr/ports
#$ find /usr/ports -type d -exec chmod g+w {} \;

# Task: Add admin
# add doug to wheel and wsrc

# ROOTBSD forgets the xshare55.tgz set?
# Task: Install set
# http://mirror.team-cymru.org/pub/OpenBSD/5.5/amd64/ (set name)

# Development environment:
# cd /usr/ports/editors/vim && env FLAVOR="no_x11 perl python ruby" make install
# zsh
# tmux
# python
# ruby
# node
# git

# Install znc
# add to crontab: @reboot /usr/local/bin/znc >/dev/null 2>&1
# steal znc config!
# -- uses webadmin though

